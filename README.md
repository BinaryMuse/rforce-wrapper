rforce-wrapper
==============

RForce-wrapper creates a wrapper around RForce to make it easier to use.

[RForce](https://github.com/undees/rforce) is a great binding to the
Salesforce Web Services API. RForce transparently turns method calls into
SOAP method calls against the Salesforce API. RForce-wrapper creates objects
and methods that wrap RForce, providing a more concrete API against
Salesforce's own SOAP API, and provides error checking and basic result
parsing.

Documentation
-------------

Detailed API documentation can be found at
[http://rubydoc.info/github/BinaryMuse/rforce-wrapper/frames](http://rubydoc.info/github/BinaryMuse/rforce-wrapper/frames).

Notes
-----

RForce-wrapper tries to match the Salesforce Web Services API as closely
as possible, matching method names and arguments. Most places where the 
Salesforce API allows an array for an argument, RForce-wrapper allows either
an array or multiple arguments (via a splat).

All calls via RForce-wrapper have their results wrapped in an array. You can
disable this functionality by specifying the option `:wrap_results => false`
in the constructor to your `RForce::Wrapper::Connection`.

Examples
--------

### Overview

    require 'rforce-wrapper'
    
    # Connect to our sandbox.
    sf = RForce::Wrapper::Connection.new('email', 'password' + 'token', {:environment => :test})
    
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

### Creating a Record

    new_account = {
      :type      => 'Account',
      :firstName => 'John',
      :lastName  => 'Smith'
    }
    puts sf.create(new_account).first

License
-------

RForce-wrapper is licensed under the MIT license.

    Copyright (c) 2011 Brandon Tilley

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
