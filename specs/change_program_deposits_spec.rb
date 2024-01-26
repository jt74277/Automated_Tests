# frozen_string_literal: true

require 'spec_helper'

RSpec.feature 'Change Program Deposits -' do
  let(:sf_base_page)  { SfBasePage.new }
  let(:case_page)     { CasePage.new }
  let(:change_program_deposits_case_page) { ChangeProgramDepositsCasePage.new }
  let(:glue_api)      { GlueAPI.new }
  let(:test_data)     { glue_api.create_data('qa_program', 'pre_settlement_tradelines_ready_for_offer') }
  let(:sfid)          { test_data['sfid'] }

  before do
    navigate_to_program_by_sfid(sfid, app: 'CX360', login_as: 'servicecloud')
    create_case(type: 'Change Program Deposits', related_contact: :first)
    wait_for_salesforce_page_load
    expect(change_program_deposits_case_page.other_deposit_changes_button).to have_text('Other Deposit Changes', wait: 5)
    change_program_deposits_case_page.other_deposit_changes_button.click
    wait_for_salesforce_page_load
    expect(change_program_deposits_case_page.add_deposit).to be_visible
    expect(case_page.close_case_button).to be_visible
  end

  scenario 'Update Intent and Reason and Close case' do
    expect(page).to have_content('Program Details')
    change_program_deposits_case_page.update_intent_and_reason
    wait_for_popup('field reasons updated successfully')
    case_page.close_case(case_status: 'No Action')
    wait_for_popup('Case updated successfully')
  end

  scenario 'Checks that preview button is disabled after adding deposits' do
    change_program_deposits_case_page.add_deposit.click
    change_program_deposits_case_page.scheduled_date.set((DateTime.now + 45).strftime('%m/%d/%Y'))
    change_program_deposits_case_page.amount_field.set('100')
    change_program_deposits_case_page.preview_button.click
    wait_for_popup_to_clear('Changes have been simulated.')
    expect(change_program_deposits_case_page.add_deposit).to be_disabled
    expect(change_program_deposits_case_page.preview_button).to be_disabled
    change_program_deposits_case_page.save_deposit_changes_button.click
    wait_for_popup_to_clear('The changes have been saved successfully.')
  end
end
