# frozen_string_literal: true

require 'support/page_objects/program_page'

class OnboardingCallCasePage < ProgramPage
  include RSpec::Matchers

  element :program_number, :xpath, "//*[contains(text(),'Program Number')]/..//button"
  element :next_section_button, :xpath, ".//button[text()='Next Section']"
  # Section 1
  element :yes_button, :xpath, ".//button[text()='Yes']"
  element :no_button, :xpath, ".//button[text()='No']"
  element :warm_transfer_section_title, :xpath, ".//*[text()='1. Warm Transfer']"
  # Section 2
  element :introduction_section_title, :xpath, ".//*[text()='2. Introduction and Welcome to Beyond']"
  # Section 3
  element :confirming_contact_information_section_title, :xpath, ".//*[text()='3. Confirming Contact Information']"
  element :email, :xpath, ".//lightning-input[@data-id='contactEmail']"
  element :home_phone_number, :xpath, ".//lightning-input[@data-id='contactHomePhone']"
  element :mobile_phone_number, :xpath, ".//lightning-input[@data-id='contactMobilePhone']"
  # Section 4
  element :confirming_deposits_section_title, :xpath, ".//*[text()='4. Confirming Deposits']"
  element :deposit_change_button, :xpath, ".//button[text()='Deposit Change']"
  element :bank_account_update_button, :xpath, ".//button[text()='Bank Account Update']"
  element :skip_defer_deposit_button, :xpath, ".//button[text()='Skip / Defer Deposit']"
  element :reduce_next_deposit_button, :xpath, ".//button[text()='Reduce Next Deposit']"
  element :other_deposit_changes_button, :xpath, ".//button[text()='Other Deposit Changes']"
  element :add_new_account_title, :xpath, ".//*[text()='Add New Account']"
  element :account_number_input, :xpath, ".//lightning-input[@data-id='actNumber']"
  element :routing_number_input, :xpath, ".//lightning-input[@data-id='rtNumber']"
  element :account_type_dropdown, :xpath, ".//lightning-combobox[@data-id='typePicklist']"
  element :save_bank_account_button, :xpath, ".//button[text()='Save Bank Account']"
  # Section 5
  element :send_onboarding_video_section_title, :xpath, ".//*[text()='5. Send Onboarding Video']"
  element :send_obc_video_button, :xpath, ".//button[text()='Send OBC Video']"
  # Section 6
  element :video_received_confirmation_section_title, :xpath, ".//*[text()='6. Video Received Confirmation']"
  element :tech_issue_button, :xpath, ".//button[text()='Tech Issue']"
  # Section 7
  element :client_questions_section_title, :xpath, ".//*[text()='7. Client Questions']"
  # Section 8
  element :closing_section_title, :xpath, ".//*[text()='8. Closing']"
  element :finish_button, :xpath, "//button[text()='Finish']"
  element :case_status, :xpath, "//slot/div[2]/div[@class='slds-col slds-size_1-of-6'][4]/lightning-formatted-text"

  def assert_section_one
    expect(warm_transfer_section_title).to have_text('1. Warm Transfer')
    expect(yes_button).to be_visible
    expect(no_button).to be_visible
    yes_button.click
  end

  def assert_section_three
    expect(confirming_contact_information_section_title).to have_text('3. Confirming Contact Information')
    original_url = current_url
    program_number.click
    wait_for_salesforce_page_load
    email_addy = email_address.value
    home_phone_num = home_phone.value
    mobile_phone_num = mobile_phone.value
    visit(original_url)
    wait_for_salesforce_page_load
    expect(email.value).to eq(email_addy)
    expect(home_phone_number.value).to eq(home_phone_num)
    expect(mobile_phone_number.value).to eq(mobile_phone_num)
  end

  def assert_section_four
    expect(confirming_deposits_section_title).to have_text('4. Confirming Deposits')
    original_url = current_url
    deposit_change_button.click
    wait_for_popup('Case created successfully')
    wait_for_salesforce_page_load
    expect(skip_defer_deposit_button).to be_visible
    expect(reduce_next_deposit_button).to be_visible
    expect(other_deposit_changes_button).to be_visible
    visit(original_url)
    wait_for_salesforce_page_load
    bank_account_update_button.click
    wait_for_popup('Case created successfully')
    wait_for_salesforce_page_load
    expect(add_new_account_title).to have_text('Add New Account')
    expect(account_number_input).to be_visible
    expect(routing_number_input).to be_visible
    expect(account_type_dropdown).to be_visible
    expect(save_bank_account_button).to be_visible
    visit(original_url)
  end
end
