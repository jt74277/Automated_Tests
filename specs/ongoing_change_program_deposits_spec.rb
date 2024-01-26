# frozen_string_literal: true

RSpec.feature 'Change Program Deposits -' do
  let(:program_page)  { ProgramPage.new }
  let(:change_program_deposits_case_page) { ChangeProgramDepositsCasePage.new }
  let(:glue_api)      { GlueAPI.new }
  let(:test_data)     { glue_api.create_data('qa_program', 'pre_settlement_tradelines_ready_for_offer', cft_upsert: true) }
  let(:sfid)          { test_data['sfid'] }

  before do
    navigate_to_program_by_sfid(sfid, app: 'CX360', login_as: 'servicecloud')
    expect(program_page.new_case_button).to be_visible
    scroll_down
    page.find(:xpath, "//span[@title='(10+)']", wait: 10)
    expect(program_page.transaction_name_rows.count).to eq 10
    page.refresh
    wait_for_salesforce_page_load
    create_case(type: 'Change Program Deposits', related_contact: :first)
    wait_for_salesforce_page_load
    expect(change_program_deposits_case_page.other_deposit_changes_button).to have_text('Other Deposit Changes', wait: 5)
    change_program_deposits_case_page.other_deposit_changes_button.click
    wait_for_salesforce_page_load
    expect(page).to have_content('Ongoing Change Simulator')
    expect(page).to have_content('All Ongoing changes need to be completed prior to any One-off changes')
  end

  scenario 'Monthly Frequency-- Ongoing Deposit Change E2E' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Monthly', first_deposit: 'Last Day of Month', amount: 'Updated', total_term: '18')
    wait_for_popup('Changes have been simulated.', wait: 8)
    wait_for_popup('Please review the schedule before saving.', wait: 8)
    change_program_deposits_case_page.save_ongoing_deposit_change
    wait_for_popup('The changes have been saved successfully.')
  end
end
