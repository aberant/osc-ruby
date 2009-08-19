class MessageBuilder
  
  def initialize
    @address = ""
    @tags = []
    @values = []
  end
  
  def with_address( addr )
    @address = addr
    self
  end
  
  def with_float( float )
    with_arg( "f", float )
    self
  end
  
  def with_int( int )
    with_arg( "i", int )
    self
  end
  
  def with_string( string )
    with_arg( "s", string )
    self
  end
  
  
  def build
    OSC::Message.new( @address , @tags.join, *@values)
  end
  
private

  def with_arg( tag, value )
    @tags << tag 
    @values << value 
  end
end