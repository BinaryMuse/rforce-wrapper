module RForce
  module Wrapper
    class SalesforceFaultException < Exception
      def initialize(code, string)
        @code   = code
        @string = string
      end

      def to_s
        "#{@code}: #{@string}"
      end
    end
  end
end
