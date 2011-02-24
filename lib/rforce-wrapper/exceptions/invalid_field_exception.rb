module RForce
  module Wrapper
    # Raised if an invalid field is accessed via `[]` or `[]=` in
    # `RForce::Wrapper::Types::SObject`.
    #
    # @see RForce::Wrapper::Types::SObject#[]
    # @see RForce::Wrapper::Types::SObject#[]=
    class InvalidFieldException < Exception; end
  end
end
