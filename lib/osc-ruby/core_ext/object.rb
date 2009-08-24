# lifted from the ruby programming language book, thx matz!

# Obtain the Mutex associated with the object o, and then evaluate 
# the block under the protection of that Mutex. 
# This works like the synchronized keyword of Java. 
def synchronized(o) 
  o.mutex.synchronize { yield } 
end 
# Object.mutex does not actually exist. We've got to define it. 
# This method returns a unique Mutex for every object, and 
# always returns the same Mutex for any particular object. 
# It creates Mutexes lazily, which requires synchronization for 
# thread safety. 
class Object 
  # Return the Mutex for this object, creating it if necessary. 
  # The tricky part is making sure that two threads don't call 
  # this at the same time and end up creating two different mutexes. 
  def mutex 
    # If this object already has a mutex, just return it 
    return @__mutex if @__mutex 
        
    # Otherwise, we've got to create a mutex for the object. 
    # To do this safely we've got to synchronize on our class object. 
    synchronized(self.class) { 
      # Check again: by the time we enter this synchronized block, 
      # some other thread might have already created the mutex. 
      @__mutex = @__mutex || Mutex.new 
    } 
    # The return value is @__mutex 
  end 
end 
# The Object.mutex method defined above needs to lock the class 
# if the object doesn't have a Mutex yet. If the class doesn't have 
# its own Mutex yet, then the class of the class (the Class object) 
# will be locked. In order to prevent infinite recursion, we must 
# ensure that the Class object has a mutex. 
Class.instance_eval { @__mutex = Mutex.new } 
