module RForce
  module Wrapper
    # Raised if an invalid environment type is passed to
    # `RForce::Wrapper::Connection.url_for_environment`, usually via
    # `RForce::Wrapper::Connection#initialize`.
    #
    # @see RForce::Wrapper::Connection.url_for_environment
    # @see RForce::Wrapper::Connection#initialize
    class InvalidEnvironmentException < Exception; end
  end
end
