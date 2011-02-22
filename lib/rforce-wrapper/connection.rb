require 'rforce'
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

      attr_reader :binding

      # Create a connection to the database with the given email and password/token combo.
      # Optional parameter type can be used to specify live or test accounts (defaults to live).
      def initialize(email, pass, type = :live)
        @binding = RForce::Binding.new url_for_environment(type)
        @binding.login email, pass
      end

      # def sObject(type ,id = nil)
      #   sobject = SObject.new(type, id, self)
      # end

      protected

        # Make the SOAP API call identified by method
        # using the given params.
        def make_api_call(method, params = nil)
          if params
            result = @binding.send method, params
          else
            result = @binding.send method
          end

          # Errors will result in result[:Fault] being set
          if result[:Fault]
            raise RForce::Wrapper::SalesforceFaultException.new result[:Fault][:faultcode], result[:Fault][:faultstring]
          end

          # If the result was successful, there will be a key: "#{method.to_s}Response".to_sym
          # which will contain the key :result
          result_field_name = method.to_s + "Response"
          if result[result_field_name.to_sym]
            return ensure_array result[result_field_name.to_sym][:result]
          else
            return nil
          end
        end

        # Returns the URL for the given environment type.
        # Valid types are :test and :live.
        def url_for_environment(type)
          case type
          when :test
            'https://test.salesforce.com/services/Soap/u/21.0'
          when :live
            'https://www.salesforce.com/services/Soap/u/21.0'
          end
        end

        # Ensures that the parameter is wrapped in an array.
        # Parameter is returned as-is if it is already an array.
        def ensure_array(thing)
          if thing.is_a? Array
            thing
          else
            [thing]
          end
        end
    end
  end
end
