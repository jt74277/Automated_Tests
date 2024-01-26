# frozen_string_literal: true

RSpec.feature 'Change Program Deposits -' do
  let(:program_page)  { ProgramPage.new }
  let(:change_program_deposits_case_page) { ChangeProgramDepositsCasePage.new }
  let(:glue_api)      { GlueAPI.new }
  let(:test_data)     { glue_api.create_data('qa_program', 'pre_settlement_tradelines_ready_for_offer') }
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

  scenario 'Monthly Frequency- Deposit Start Date is missing-- Ongoing Change Simulate' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Monthly')
    wait_for_popup('S: Deposit Start Day is missing', wait: 8)
    wait_for_popup('Required : please select Deposit Start Day for Monthly/Bi-Weekly')
  end

  scenario 'Semi-Monthly Frequency- Deposit 1 or Deposit 2 is missing-- Ongoing Change Simulate' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Semi_monthly')
    wait_for_popup('S: Deposit 1 or Deposit 2 is missing', wait: 8)
    wait_for_popup('Required: please select value for Deposit 1 and Deposit 2')
  end

  scenario 'Bi-weekly Frequency-- Ongoing Change Simulate' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Bi_weekly', first_deposit: '1', amount: 'Updated', total_term: '60')
    wait_for_popup('Changes have been simulated.', wait: 8)
    wait_for_popup('Please review the schedule before saving.')
  end

  scenario 'Semi-Monthly Frequency-- Ongoing Change Simulate' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Semi_monthly', first_deposit: '15', second_deposit: 'Last Day of Month', amount: 'Updated', total_term: '60')
    wait_for_popup('Changes have been simulated.', wait: 8)
    wait_for_popup('Please review the schedule before saving.')
  end

  scenario 'Monthly Frequency-- Ongoing Change Simulate' do
    change_program_deposits_case_page.ongoing_change_simulator(frequency: 'Monthly', first_deposit: 'Last Day of Month', amount: 'Updated', total_term: '12')
    wait_for_popup('Changes have been simulated.', wait: 8)
    wait_for_popup('Please review the schedule before saving.')
  end
end
