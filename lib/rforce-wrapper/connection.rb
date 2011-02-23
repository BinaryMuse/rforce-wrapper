require 'rforce'
require 'rforce-wrapper/utilities'
require 'rforce-wrapper/salesforce_fault_exception'
require 'rforce-wrapper/methods/core'
require 'rforce-wrapper/methods/describe'
require 'rforce-wrapper/methods/utility'

module RForce
  module Wrapper
    class Connection
      include RForce::Wrapper::CoreMethods
      include RForce::Wrapper::DescribeMethods
      include RForce::Wrapper::UtilityMethods

      # Returns the underlying `RForce::Binding` object.
      attr_reader :binding

      # Creates a new connect to the Salesforce API using the given email and
      # password or password+token combination and connects to the API.
      # Additional options can be specified.
      #
      # @param [String] email the email address of the account to log in with
      # @param [String] pass the password or password+token combo for the account
      # @param [Hash] options additional options for the connection
      # @option options [:live, :test] :environment the environment, defaults to `:live`
      # @option options [String] :version the version of the Salesforce API to use, defaults to `'21.0'`
      # @option options [Boolean] :wrap_results whether or not to wrap single-element results into an array, defaults to `true`
      def initialize(email, pass, options = {})
        options = {
          :environment  => :live,
          :version      => '21.0',
          :wrap_results => true
        }.merge(options)
        @wrap_results = options[:wrap_results]
        @binding = RForce::Binding.new RForce::Wrapper::Connection.url_for_environment(options[:environment], options[:version])
        @binding.login email, pass
      end

      # Returns the URL for the given environment type and version.
      #
      # @param [:live, :test] type the environment type
      # @param [String] version the version of the Salesforce API to use
      def self.url_for_environment(type, version)
        case type
        when :test
          "https://test.salesforce.com/services/Soap/u/#{version}"
        when :live
          "https://www.salesforce.com/services/Soap/u/#{version}"
        else
          raise "Invalid environment type: #{type.to_s}"
        end
      end

      protected

        # Performs a SOAP API call via the underlying `RForce::Binding`
        # object. Raises an exception if a `Fault` is detected. Returns
        # the data portion of the result (wrapped in an `Array` if
        # `wrap_results` is true; see {#initialize}).
        #
        # @param [Symbol] method the API method to call
        # @param [Array, Hash, nil] params the parameters to pass to the API
        #   method. `RForce::Binding` expects either an `Array` or `Hash` to
        #   turn into SOAP arguments. Pass `nil`, `[]` or `{}` if the API
        #   call takes no parameters.
        # @raise [RForce::Wrapper::SalesforceFaultException] indicates that
        #   a `Fault` was returned from the Salesforce API
        def make_api_call(method, params = nil)
          if params
            result = @binding.send method, params
          else
            result = @binding.send method, []
          end

          # Errors will result in result[:Fault] being set
          if result[:Fault]
            raise RForce::Wrapper::SalesforceFaultException.new result[:Fault][:faultcode], result[:Fault][:faultstring]
          end

          # If the result was successful, there will be a key: "#{method.to_s}Response".to_sym
          # which will contain the key :result
          result_field_name = method.to_s + "Response"
          if result[result_field_name.to_sym]
            data = result[result_field_name.to_sym][:result]
            return @wrap_results ? RForce::Wrapper::Utilities.ensure_array(data) : data
          else
            return nil
          end
        end
    end
  end
end
