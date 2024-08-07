# frozen_string_literal: true

class ChangeProgramDepositsCasePage < CasePage
  set_url '/lightning/r/Case/{sfid}/view'
  set_url_matcher 'lightning/r/Case/.*/view'

  element :reset_button, :xpath, "//button[text()='Reset']"
  element :other_deposit_changes_button, :xpath, "//button[@data-id='Other']"

  # Ongoing Change Simulator
  element :bi_weekly, :xpath, "//input[@value='Bi-Weekly']"
  element :semi_monthly, :xpath, "//input[@value='Semi-Monthly']"
  element :monthly, :xpath, "//input[@value='Monthly']"
  element :term_change, :xpath, "//input[@data-id='term-change']"
  elements :term_length, :xpath, "//span[text()='36']"
  element :start_day_button, :xpath, "//button[@aria-label='Start Day of the Month - Current Selection: Select an Option']"
  element :first_deposit_button, :xpath, "//button[@aria-label='Day of Month: 1st Deposit - Current Selection: Select an Option']"
  element :second_deposit_button, :xpath, "//button[@aria-label='Day of Month: 2nd Deposit - Current Selection: Select an Option']"
  element :case_type_option, :xpath, '//lightning-base-combobox-item'
  element :current_amount, :xpath, "//input[@value='currentdepositamount']"
  element :updated_amount, :xpath, "//input[@value='updateddepositamount']"
  element :term_slider, :xpath, "//input[@data-id='term-change']"
  element :preview_changes_button, :xpath, "(//lightning-button/button[@title='Preview Change'])[1]"
  element :i_understand_check_box, :xpath, "//lightning-input[@data-id='confirmCheck']/lightning-primitive-input-checkbox/div/span/input"
  element :save_ongoing_changes_button, :xpath, "//button[@name='Save Ongoing Changes']"

  # Deposit Change Reason
  element :deposit_change_dropdown, :xpath, './/span', text: 'Deposit Change Reason'
  element :select_intent_dropdown, :xpath, "//span[contains(text(),'Select Intent')]"
  element :select_reason_dropdown, :xpath, "//span[contains(text(),'Select Reason')]"
  element :update_intent_and_reason_button, :xpath, './/button', text: 'Update Intent and Reason'
  element :intent, :xpath, "//span[contains(text(),'Defer deposit/payment')]"
  element :reason, :xpath, "//span[contains(text(),'Job loss/reduced income')]"

  # Scheduled Transactions
  element :add_deposit, :xpath, './/button', text: 'Add Deposit'
  element :scheduled_date, :xpath, "(//input[@name='ScheduledDate'])[1]"
  element :amount_field, :xpath, "(//input[@name='Amount'])[1]"
  element :preview_button, :xpath, "(//button[text()='Preview Change'])[1]"
  element :save_deposit_changes_button, :xpath, "//button[text()='Save Deposit Changes']"

  def frequencies
    {
      Bi_weekly: bi_weekly,
      Semi_monthly: semi_monthly,
      Monthly: monthly
    }
  end

  def amounts
    {
      Current: current_amount,
      Updated: updated_amount
    }
  end

  def ongoing_change_simulator(frequency: nil, first_deposit: nil, second_deposit: nil, amount: nil, total_term: nil)
    scroll_down
    Wait.until(wait: 10, max: 25) { term_length.count > 1 }
    frequencies[frequency.to_sym].click if frequency
    if first_deposit && frequency != 'Semi_monthly'
      start_day_button.click
      all(:xpath, "//span[@title='#{first_deposit}']").first.click
    elsif second_deposit && frequency == 'Semi_monthly'
      first_deposit_button.click
      all(:xpath, "//span[@title='#{first_deposit}']").first.click
      second_deposit_button.click
      all(:xpath, "//span[text()='#{second_deposit}']").last.click
    end

    amounts[amount.to_sym].click if amount
    term_change.set total_term if total_term
    click_button 'Preview Change'
  end

  def save_ongoing_deposit_change
    # preview button remains selected after clicking.
    # hit tab to move down, then space to select.
    preview_changes_button.send_keys(:tab)
    i_understand_check_box.send_keys(:space)
    save_ongoing_changes_button.click
  end

  def update_intent_and_reason
    deposit_change_dropdown.click
    select_intent_dropdown.click
    intent.click
    select_reason_dropdown.click
    reason.click
    update_intent_and_reason_button.click
  end
end
