module RForce
  module Wrapper
    # Raised if an invalid environment type is passed to
    # `RForce::Wrapper::Connection.new`.
    #
    # @see RForce::Wrapper::Connection#initialize
    class InvalidEnvironmentException < Exception; end
  end
end
