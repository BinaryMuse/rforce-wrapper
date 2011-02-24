require 'rforce-wrapper/exceptions/invalid_field_exception'

module RForce
  module Wrapper
    module Types
      # Represents an sObject in the Salesforce database.
      class SObject
        # @return [String] the type of the sObject (e.g. `Account` or `Lead`)
        attr_accessor :type

        # @param [String, Array] fieldsToNull list of field names to null out
        #   when the sObject is updated
        # @return [String] a list of field names to null out when the sObject
        #   is updated
        attr_reader :fieldsToNull

        # @return [String] the Salesforce ID of the sObject
        attr_accessor :id

        # Fields that cannot be set via {#[]=}.
        INVALID_FIELDS = ['type', 'fieldsToNull', 'id']

        # Creates a new sObject with the given parameters and empty fields.
        #
        # @param [String] type the type of sObject (e.g. `Account` or `Lead`)
        # @param [String] fieldsToNull a list of field names to null out when
        #   the sObject is updated.
        # @param [String] id the Salesforce ID of the sObject
        def initialize(type, fieldsToNull = nil, id = nil)
          @type         = type
          @fieldsToNull = fieldsToNull
          @fieldsToNull = @fieldsToNull.join(", ") if @fieldsToNull.is_a? Array
          @id           = id
          @fields       = {}
        end

        def fieldsToNull=(fields)
          @fieldsToNull = fields
          @fieldsToNull = @fieldsToNull.join(", ") if @fieldsToNull.is_a? Array
        end

        # Sets the value of a field on the sObject. Cannot be used with
        # `type`, `id`, or `fieldsToNull` (access those directly as methods
        # on the sObject). The method is written such that the following
        # four keys are equal to each other: `'FirstName'`, `'firstName'`,
        # `:FirstName`, `:firstName`. The case of every character after the
        # first, however, must match.
        #
        # @param [Symbol, String] key the name of the field
        # @param [String] value the value to set to the field
        # @return [nil]
        def []=(key, value)
          key = self.class.make_indifferent_key(key)
          raise InvalidFieldException.new if INVALID_FIELDS.map{ |f| f.to_s.downcase }.include? key.downcase
          value = value.to_s unless value.is_a? String
          @fields[key] = value
        end

        # Returns the value of a field on the sObject. This method is subject
        # to all the same features and restrictions of {#[]=}.
        #
        # @param [Symbol, String] key the name of the field
        # @return [String] the value of the field
        def [](key)
          key = self.class.make_indifferent_key(key)
          @fields[key]
        end

        # Modifies the given string or symbol into a string with the first
        # letter capitalized. For use with hashes to ensure all the keys
        # are the same format.
        #
        # @param [Symbol, String] key the string to make indifferent
        # @return [String] the indifferent version of the string
        def self.make_indifferent_key(key)
          key = key.to_s
          key.sub /^(.){1}/ do |match|
            $1.capitalize
          end
        end

        # Returns a hash representation of the SObject for use in RForce SOAP
        # calls.
        #
        # @return [Hash] a hash representation of the sObject
        def to_hash
          hash = @fields
          hash.merge! :type => @type
          hash.merge! :Id => @id unless @id.nil?
          hash.merge! :fieldsToNull => @fieldsToNull unless @fieldsToNull.nil? || @fieldsToNull.empty?
          hash
        end
      end
    end
  end
end
