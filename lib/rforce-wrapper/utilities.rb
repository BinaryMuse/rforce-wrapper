module RForce
  module Wrapper
    class Utilities
      # Ensures that the parameter is wrapped in an array.
      # Parameter is returned as-is if it is already an array.
      def self.ensure_array(thing)
        if thing.is_a? Array
          thing
        else
          [thing]
        end
      end
    end
  end
end
