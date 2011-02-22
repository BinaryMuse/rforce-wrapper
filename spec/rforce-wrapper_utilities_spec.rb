require 'rforce-wrapper'

describe RForce::Wrapper::Utilities do
  context "#ensure_array" do
    it "should pass an array through unmodified" do
      RForce::Wrapper::Utilities.ensure_array([1, 2, 3]).should == [1, 2, 3]
    end

    it "should wrap non-arrays in an array" do
      RForce::Wrapper::Utilities.ensure_array('1, 2, 3').should == ['1, 2, 3']
    end
  end
end
