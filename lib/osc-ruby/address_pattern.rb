module OSC
  class AddressPattern
    def initialize( pattern )
      @pattern = pattern
      
      generate_regex_from_pattern
    end
    
    def match?( address )
      !!(@re.nil? || @re.match( address ))
    end
    
private 
    def generate_regex_from_pattern
      case @pattern
        when NIL; @re = @pattern
        when Regexp; @re = @pattern
        when String
          
          # commented out ones mean they were in the original lib
          # but i'm unsure what they do
          # @pattern.gsub!(/[.^(|)]/, '\\1')
          
          # handles osc single char wildcard matching
          @pattern.gsub!(/\?/, '[^/]')
          
          # handles osc * - 0 or more matching
          @pattern.gsub!(/\*/, '[^/]*')
          
          # handles [!] matching
          @pattern.gsub!(/\[!/, '[^')
            
            
          @pattern.gsub!(/\{/, '(')
          @pattern.gsub!(/,/, '|')
          @pattern.gsub!(/\}/, ')')
          
          # @pattern.gsub!(/\A/, '\A')
          
          # keeps from matching beyond the end, 
          # eg. pattern /hi does not match /hidden
          @pattern.gsub!(/\z/, '\z')

          @re = Regexp.new(@pattern)
        else
          raise ArgumentError, 'invalid pattern'
      end
    end
  end
end
