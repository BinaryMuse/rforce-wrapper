rforce-wrapper
==============

RForce-wrapper creates a wrapper around RForce to make it easier to use.

[RForce](https://github.com/undees/rforce) is a great binding to the
Salesforce Web Services API. RForce transparently turns method calls into
SOAP method calls against the Salesforce API. RForce-wrapper creates objects
and methods that wrap RForce, providing a more concrete API against
Salesforce's own SOAP API, and provides error checking and basic result
parsing.

RForce-wrapper tries to match the Salesforce Web Services API as closely
as possible, matching method names and arguments. Anywhere the Salesforce API
allows an array for an argument, RForce-wrapper allows either an array or
multiple arguments.

Examples
--------

    require 'rforce-wrapper'
    
    # Connect to our sandbox.
    sf = RForce::Wrapper::Connection.new('email', 'password' + 'token', :test)
    
    # Describe the sObject "Account" and get a list of fields.
    account_description = sf.describeSObjects('Account').first
    # Filter out any fields that are marked as deprecated and hidden.
    fields = account_description[:fields].map do |field|
      next if field[:deprecatedAndHidden] == "true"
      field[:name]
    end
    
    # Fetch some accounts.
    # Note that although the official API takes an array of IDs as the last
    # parameter (see http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_retrieve.htm),
    # we're simply passing in additional parameters. An array would also have worked fine.
    accounts = sf.retrieve fields.join(', '), 'Account', '001S000000MBfXAIA1', '001S000000QJAeZIAX'
    
    accounts.each do |account|
      puts account[:IsPersonAccount] == "true" ? "- Person Account" : "- Business Account"
      puts "         ID: #{account[:Id]}"
      puts "       View: #{account_description[:urlDetail].sub "{ID}", account[:Id]}"
      puts
    
      if account[:IsPersonAccount] == "true"
        puts " First Name: #{account[:FirstName]}"
        puts "  Last Name: #{account[:LastName]}"
        puts "      Phone: #{account[:PersonHomePhone]}"
        puts "      Email: #{account[:PersonEmail]}"
      else
        puts "         ID: #{account[:Id]}"
        puts "       Name: #{account[:Name]}"
        puts "      Phone: #{account[:Phone]}"
      end
      puts
    end

Output:

    - Person Account
             ID: 001S000000MBfXAIA1
           View: https://cs1.salesforce.com/001S000000MBfXAIA1
    
     First Name: Sample
      Last Name: Person
          Phone: (555) 555-1234
          Email: sample.person@company.com
    
    - Business Account
             ID: 001S000000QJAeZIAX
           View: https://cs1.salesforce.com/001S000000QJAeZIAX
    
           Name: Sample Company
          Phone: (555) 555-4321
