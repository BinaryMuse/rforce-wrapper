require 'rforce-wrapper/types/sobject'

describe RForce::Wrapper::Types::SObject do
  before :all do
    SObject = RForce::Wrapper::Types::SObject
  end

  context "constructor" do
    it "should default to a nil id" do
      so = SObject.new('Account', 'FirstName')
      so.id.should be_nil
    end

    it "should default to nil for fieldsToNull" do
      so = SObject.new('Account')
      so.fieldsToNull.should be_nil
    end

    it "should set the correct type" do
      so = SObject.new('Account')
      so.type.should == 'Account'
    end

    it "should allow an array for fieldsToNull parameter" do
      so = SObject.new('Account', ['FirstName', 'LastName'])
      so.fieldsToNull.should == 'FirstName, LastName'
    end
  end

  context "#fieldsToNull=" do
    before :each do
      @so = SObject.new('Account')
    end

    it "should accept a string" do
      @so.fieldsToNull = 'Account, Lead'
      @so.fieldsToNull.should == 'Account, Lead'
    end

    it "should accept an array" do
      @so.fieldsToNull = ['Account', 'Lead']
      @so.fieldsToNull.should == 'Account, Lead'
    end
  end

  # TODO: these tests need to be isolated
  context "#[]= and #[]" do
    before :each do
      @so = SObject.new('Account')
    end

    it "should allow setting and getting fields via string" do
      @so['FirstName'] = 'Brandon'
      @so['FirstName'].should == 'Brandon'
    end

    it "should allow setting and getting fields via capitalized symbol" do
      @so[:FirstName] = 'Joe'
      @so[:FirstName].should == 'Joe'
    end

    it "should allow setting and getting fields via lowercase symbol" do
      @so[:firstName] = 'Andy'
      @so[:firstName].should == 'Andy'
    end

    it "should get the same value via string, capitalized symbol, and lowercase symbol when set with string" do
      @so['FirstName'] = 'Jonathan'
      @so['FirstName'].should == 'Jonathan'
      @so[:FirstName].should == 'Jonathan'
      @so[:firstName].should == 'Jonathan'
    end

    it "should get the same value via string, capitalized symbol, and lowercase symbol when set with uppercase symbol" do
      @so[:FirstName] = 'Jonathan'
      @so['FirstName'].should == 'Jonathan'
      @so[:FirstName].should == 'Jonathan'
      @so[:firstName].should == 'Jonathan'
    end

    it "should get the same value via string, capitalized symbol, and lowercase symbol when set with lowercase symbol" do
      @so[:firstName] = 'Jonathan'
      @so['FirstName'].should == 'Jonathan'
      @so[:FirstName].should == 'Jonathan'
      @so[:firstName].should == 'Jonathan'
    end

    it "shoudl convert non-string values to a string" do
      @so[:field] = :something
      @so[:field].should == :something.to_s
    end

    it "should raise an exception if type is set" do
      lambda {
        @so[:type] = 'something'
      }.should raise_error RForce::Wrapper::InvalidFieldException
    end
  end

  context ".make_indifferent_key" do
    it "should transform a symbol into a string" do
      SObject.make_indifferent_key(:mysymbol).class.should == String
    end

    it "should capitalize the first letter of a string" do
      SObject.make_indifferent_key('mystring').should == 'Mystring'
    end

    it "should not modify a string after the first character is capitalized" do
      SObject.make_indifferent_key('myString').should == 'MyString'
    end
  end

  context "#to_hash" do
    before :each do
      @so = SObject.new('Account')
    end

    it "should include the type in the hash" do
      @so.to_hash.keys.include?(:type).should == true
    end

    it "should not include a blank fieldsToNull in the hash" do
      @so.fieldsToNull = ''
      @so.to_hash.keys.include?(:fieldsToNull).should == false
    end

    it "should not include an empty array fieldsToNull in the hash" do
      @so.fieldsToNull = []
      @so.to_hash.keys.include?(:fieldsToNull).should == false
    end

    it "should not include a nil fieldsToNull in the hash" do
      @so.fieldsToNull = nil
      @so.to_hash.keys.include?(:fieldsToNull).should == false
    end

    it "should not include a nil ID in the hash" do
      @so.id = nil
      @so.to_hash.keys.include?(:id).should == false
    end

    it "should not include a blank ID in the hash" do
      @so.id = ''
      @so.to_hash.keys.include?(:id).should == false
    end

    it "should include the correct fieldsToNull if set via string" do
      @so.fieldsToNull = 'FirstName, LastName'
      @so.to_hash[:fieldsToNull].should == 'FirstName, LastName'
    end

    it "should include the correct fieldsToNull if set via array" do
      @so.fieldsToNull = ['FirstName', 'LastName']
      @so.to_hash[:fieldsToNull].should == 'FirstName, LastName'
    end
  end
end
