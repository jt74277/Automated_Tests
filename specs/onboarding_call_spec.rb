# frozen_string_literal: true

require 'spec_helper'

RSpec.feature 'Onboarding Call Case' do
  let(:sf_base_page)              { SfBasePage.new }
  let(:program_page)              { ProgramPage.new }
  let(:onboarding_call_case_page) { OnboardingCallCasePage.new }
  let(:glue_api)                  { GlueAPI.new }
  let(:test_data)                 { glue_api.create_data('qa_case', 'type_onboarding_call') }
  let(:sfid)                      { test_data['sfid'] }

  scenario 'Onboarding Call case Happy Path E2E' do
    navigate_to_program_by_sfid(sfid, app: 'CX360', login_as: 'servicecloud')
    Wait.wait_for_element_visible(onboarding_call_case_page.warm_transfer_section_title)
    onboarding_call_case_page.assert_section_one
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.introduction_section_title)
    expect(onboarding_call_case_page.introduction_section_title).to have_text('2. Introduction and Welcome to Beyond')
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.confirming_contact_information_section_title)
    onboarding_call_case_page.assert_section_three
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.confirming_deposits_section_title)
    onboarding_call_case_page.assert_section_four
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.send_onboarding_video_section_title)
    expect(onboarding_call_case_page.send_onboarding_video_section_title).to have_text('5. Send Onboarding Video')
    expect(onboarding_call_case_page.send_obc_video_button).to be_visible
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.video_received_confirmation_section_title)
    expect(onboarding_call_case_page.video_received_confirmation_section_title).to have_text('6. Video Received Confirmation')
    expect(onboarding_call_case_page.tech_issue_button).to be_visible
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.client_questions_section_title)
    expect(onboarding_call_case_page.client_questions_section_title).to have_text('7. Client Questions')
    onboarding_call_case_page.next_section_button.click
    Wait.wait_for_element_visible(onboarding_call_case_page.closing_section_title)
    expect(onboarding_call_case_page.closing_section_title).to have_text('8. Closing')
    onboarding_call_case_page.finish_button.click
    wait_for_popup('Case Completed')
    expect(onboarding_call_case_page.case_status.text).to eq 'Complete'
    onboarding_call_case_page.program_number.click
    program_page.assert_case_status
  end
end
