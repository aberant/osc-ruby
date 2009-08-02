module OSC
  class AddressPattern
    def initialize( pattern )
      @pattern = pattern
      
      generate_regex_from_pattern
    end
    
    def match?( address )
      # if the regex is empty(matches anything) OR regex matches the address
      !!(@re.nil? || @re.match( address ))
    end
    
private 
    def generate_regex_from_pattern
      case @pattern
        when NIL; @re = @pattern
        when Regexp; @re = @pattern
        when String
          
          # maybe this is simple regex escaping?
          # @pattern.gsub!(/[.^(|)]/, '\\1')
          # @pattern.gsub!(/\?/, '[^/]')
          # @pattern.gsub!(/\*/, '[^/]*')
          # @pattern.gsub!(/\[!/, '[^')
          # @pattern.gsub!(/\{/, '(')
          # @pattern.gsub!(/,/, '|')
          # @pattern.gsub!(/\}/, ')')
          # @pattern.gsub!(/\A/, '\A')
          # @pattern.gsub!(/\z/, '\z')

          @re = Regexp.new(@pattern)
        else
          raise ArgumentError, 'invalid pattern'
      end
    end
  end
end
