# frozen_string_literal: true

require 'support/page_objects/case_page'

class CoClientCasePage < CasePage
  include RSpec::Matchers

  # Co-Client Details Form
  section :first_name_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='FirstName']/*/div/div/input"
  section :last_name_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='LastName']"
  section :email_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='Email']"
  section :birthdate_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='BirthDate']"
  section :military_status_dropdown, DropboxComponent, :xpath, ".//lightning-combobox[@data-id='Military_Status__c']"
  section :mobile_phone_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='MobilePhone']"
  section :home_phone_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='HomePhone']"
  section :ssn_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='SSN__c']"
  section :monthly_income_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='Monthly_Income__c']"
  section :mothers_maiden_name_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='MothersMaidenName__c']"
  section :same_address_checkbox, CheckboxComponent, :xpath, ".//lightning-input[@data-id='sasmeAsClientCheckbox']"
  section :street_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='MailingStreet']"
  section :city_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='MailingCity']"
  section :state_dropdown, DropboxComponent, :xpath, ".//lightning-combobox[@data-id='MailingState']"
  section :postal_code_input, InputTextComponent, :xpath, ".//lightning-input[@data-id='MailingPostalCode']"

  # Buttons
  element :create_co_client_button, :xpath, ".//button[text()='Create Co-Client']"
  element :next_section_button, :xpath, ".//button[text()='Next Section']"
  element :generate_ea_button, :xpath, ".//button[text()='Generate EA']"
  element :clear_error_modal_button, :xpath, ".//button[@title='Close this window']"

  # EA modal
  element :send_ea_button, :xpath, ".//button[contains(text(),'Send EA')]"

  def fill_out_co_client_form(co_client = 'ArchieBunker', inputs = {})
    test_file = find_lead_data(co_client)

    data = {
      first_name: test_file[co_client]['firstname'],
      last_name: test_file[co_client]['lastname'],
      email: "automation+#{Time.new.to_i}@beyondfinance.com",
      birthdate: test_file[co_client]['birthdate'],
      military: test_file[co_client]['military'],
      mobile: Faker::Base.numerify('59#-###-####'),
      home_phone: Faker::Base.numerify('59#-###-####'),
      ssn: Faker::Base.numerify('###-##-####'),
      monthly_income: test_file[co_client]['income'],
      mother: test_file[co_client]['mother'],
      street_address: test_file[co_client]['street_address'],
      city: test_file[co_client]['city'],
      state: test_file[co_client]['state'],
      zip: test_file[co_client]['zipcode']
    }.merge(inputs)

    first_name_input.set data[:first_name]
    last_name_input.set data[:last_name]
    email_input.set data[:email]
    birthdate_input.set data[:birthdate]
    military_status_dropdown.set data[:military]
    mobile_phone_input.set data[:mobile]
    home_phone_input.set data[:home_phone]
    ssn_input.set data[:ssn]
    monthly_income_input.set data[:monthly_income]
    mothers_maiden_name_input.set data[:mother]
    street_input.set data[:street_address]
    city_input.set data[:city]
    state_dropdown.set data[:state]
    postal_code_input.set data[:zip]
  end
end
