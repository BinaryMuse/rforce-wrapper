require 'rforce-wrapper'
require 'uri'

describe RForce::Wrapper::Connection do
  before :each do
    RForce::Binding.any_instance.stubs(:login).returns(:login)
    RForce::Binding.any_instance.stubs(:call_remote).returns(api_response_for(API_METHOD))
    @wrapper = RForce::Wrapper::Connection.new TEST_USER, TEST_PASS_TOKEN, :live
  end

  context "#initialize" do
    it "should create an RForce binding object" do
      @wrapper.binding.should be_a RForce::Binding
    end

    it "should create an RForce binding to the correct version" do
      @wrapper = RForce::Wrapper::Connection.new TEST_USER, TEST_PASS_TOKEN, :live, '20.0'
      correct_url = RForce::Wrapper::Connection.url_for_environment(:live, '20.0')
      @wrapper.binding.url.should == URI.parse(correct_url)
    end

    it "should default to version 21.0 of the API" do
      @wrapper = RForce::Wrapper::Connection.new TEST_USER, TEST_PASS_TOKEN, :live
      correct_url = RForce::Wrapper::Connection.url_for_environment(:live, '21.0')
      @wrapper.binding.url.should == URI.parse(correct_url)
    end
  end

  context "#url_for_environment" do
    it "should return the correct URL for a live environment and version number" do
      live_url = 'https://www.salesforce.com/services/Soap/u/20.5'
      RForce::Wrapper::Connection.url_for_environment(:live, '20.5').should == live_url
    end

    it "should return the correct url for a test environment and version number" do
      test_url = 'https://test.salesforce.com/services/Soap/u/20.5'
      RForce::Wrapper::Connection.url_for_environment(:test, '20.5').should == test_url
    end

    it "should raise an exception when called with an invalid environment" do
      lambda {
        RForce::Wrapper::Connection.url_for_environment(:awesomeness)
      }.should raise_error
    end
  end

  context "#make_api_call" do
    it "should raise an exception if a fault is found" do
      RForce::Binding.any_instance.stubs(:call_remote).returns(api_response_fault)
      lambda {
        @wrapper.send(:make_api_call, API_METHOD, ['params'])
      }.should raise_error RForce::Wrapper::SalesforceFaultException
    end

    it "should return the results sub-hash of the API call" do
      @wrapper.send(:make_api_call, API_METHOD, ['params']).should == api_results_for(API_METHOD)
    end
  end

  context "core api method" do
    context "#logout" do
      it "should call the logout API method" do
        @wrapper.expects(:make_api_call).with(:logout)
        @wrapper.logout
      end
    end

    context "#retrieve" do
      it "should call the retrieve API method correctly with one ID" do
        fieldList = 'Name, Phone'
        sObjectType = 'Account'
        id = 'abcdefg'
        @wrapper.expects(:make_api_call).with(:retrieve, [:fieldList, fieldList, :sObjectType, sObjectType, :Id, id])
        @wrapper.retrieve fieldList, sObjectType, id
      end

      it "should call the retrieve API method correctly with multiple IDs passed separately" do
        fieldList = 'Name, Phone'
        sObjectType = 'Account'
        id  = 'abcdefg'
        id2 = 'tuvwxyz'
        @wrapper.expects(:make_api_call).with(:retrieve, [:fieldList, fieldList, :sObjectType, sObjectType, :Id, id, :Id, id2])
        @wrapper.retrieve fieldList, sObjectType, id, id2
      end
    
      it "should call the retrieve API method correctly with multiple IDs passed as an array" do
        fieldList = 'Name, Phone'
        sObjectType = 'Account'
        id  = 'abcdefg'
        id2 = 'tuvwxyz'
        ids = [id, id2]
        @wrapper.expects(:make_api_call).with(:retrieve, [:fieldList, fieldList, :sObjectType, sObjectType, :Id, id, :Id, id2])
        @wrapper.retrieve fieldList, sObjectType, ids
      end
    end
  end

  context "describe API method" do
    context "#describeSObject" do
      it "should call describeSObjects with the correct type" do
        @wrapper.expects(:describeSObjects).with('Account')
        @wrapper.describeSObject 'Account'
      end
    end

    context "#describeSObjects" do
      it "should call the describeSObjects API method correctly with one type" do
        @wrapper.expects(:make_api_call).with(:describeSObjects, [:sObjectType, 'Account'])
        @wrapper.describeSObjects 'Account'
      end

      it "should call the describeSObjects API method correctly with multiple types passed separately" do
        @wrapper.expects(:make_api_call).with(:describeSObjects, [:sObjectType, 'Account', :sObjectType, 'Lead'])
        @wrapper.describeSObjects 'Account', 'Lead'
      end

      it "should call the describeSObjects API method correctly with multiple types passed as an array" do
        @wrapper.expects(:make_api_call).with(:describeSObjects, [:sObjectType, 'Account', :sObjectType, 'Lead'])
        @wrapper.describeSObjects ['Account', 'Lead']
      end
    end
  end

  context "utility API method" do
  end
end
