module RForce
  module Wrapper
    # Raised when a Salesforce Web Services API SOAP response includes a
    # `Fault` element.
    #
    # @see RForce::Wrapper::Connection#make_api_call
    class SalesforceFaultException < Exception
      # Creates a new `SalesforceFaultException` with the given code and
      # message.
      #
      # @param [String] code the code for the `Fault`
      # @param [String] message the error messages for the `Fault`
      def initialize(code, message)
        @code    = code
        @message = message
      end

      # Returns a string representation of the `Fault`, including both the
      # code and the message.
      #
      # @return [String] a string representation of the exception
      def to_s
        "#{@code}: #{@message}"
      end
    end
  end
end
