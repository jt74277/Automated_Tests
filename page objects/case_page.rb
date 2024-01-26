# frozen_string_literal: true

class CasePage < SfBasePage
  include RSpec::Matchers

  set_url '/lightning/r/Case/{sfid}/view'
  set_url_matcher 'lightning/r/Case/.*/view'

  element :button, :xpath, '//button'
  elements :tradeline_name, :xpath, "//a[contains(@title, 'PT-')]"
  element :program_number, :xpath, "//*[contains(text(),'Program Number')]/..//button"
  element :send_legal_document_instructions, :xpath, "//button[text()='Send Legal Document Instructions']"

  # Close this case modal
  element :close_case_submit_button, :xpath, "//*[@class='slds-modal__footer']//button[text()='Submit']"
  element :close_case_complete_option, :xpath, "//span[text()='Complete']"
  element :close_case_button, :xpath, './/button', text: 'Close Case'
  section :select_closed_stage, DropboxComponent, :xpath, './/button', text: 'Select closed stage...'
  section :close_status_dropdown, DropboxComponent, :xpath, "//button[@name='Status']"
  element :close_this_case_submit_button, :xpath, "//button[text()='Submit']//following::div[contains(@class, 'slds-modal__container')]/descendant::footer[contains(@class, 'slds-modal__footer')]/button[2]"

  # Case Status Complete
  element :case_status_complete, :xpath, './/lightning-formatted-text', text: 'Complete'

  # Case Details
  element :case_status, :xpath, "//slot/div[2]/div[@class='slds-col slds-size_1-of-6'][4]/lightning-formatted-text"

  # Add Tradeline case
  element :debt_owner_dropdown, :xpath, "//lightning-combobox[@data-id='manual-tradeline-debtOwner']"

  # Remove Tradeline/Multiple Tradelines case
  elements :remove_buttons, :xpath, './/button', text: 'Remove'
  elements :remove_check_boxes, :xpath, "//table[@class='slds-table slds-table_bordered slds-no-row-hover']//td//span[@class='slds-checkbox_faux']"
  element :remove_tl_button, :xpath, "//button[contains(text(),'Remove Tradeline(s)')]"
  element :tradelines_text, :xpath, './/span', text: 'Tradelines'

  section :tradeline_grid, :xpath, '//c-cx_legalintakecasescript_section2_lwc//table' do
    sections :rows, :xpath, './tbody/tr' do
      elements :cells, :xpath, './/td'
      element  :tradeline_name, :xpath, './/td[1]//a'
      element  :tradeline_status, :xpath, './/td[2]//div'
      element  :enrolled_balance, :xpath, './/td[3]//div'
      element  :entrolled_creditor_alias, :xpath, './/td[4]//div'
      element  :account_number, :xpath, './/td[5]//div'
      section  :legal_checkbox, CheckboxComponent, :xpath, './/td[6]//lightning-input'
    end
  end

  # Legal Tradeline
  section :select_tradeline, DropboxComponent, :xpath, ".//lightning-combobox[@data-id='selectedTradeline']//button"
  section :legal_status_dropdown, DropboxComponent, :xpath, ".//lightning-combobox[@data-id='legalStatus']//button"
  section :legal_service_dropdown, DropboxComponent, :xpath, "//lightning-combobox[@data-id='legalServiceSource']//button"
  section :collection_agency_input, SearchSelectComponent, :xpath, "//*[contains(text(), 'Collection Agency')]/ancestor::lightning-layout-item//following-sibling::lightning-layout-item"
  section :legal_hearing_date, DatePickerComponent, :xpath, "//lightning-input[@data-id='plHearingDate']"
  element :mark_legal_submit, :xpath, './/button', text: 'Submit'
  element :close_legal_case, :xpath, "//span[contains(text(),'Select closed stage...')]"
  element :legal_close_status, :xpath, "//span[contains(text(),'Complete')]"
  element :legal_case_submit, :xpath, './/button', text: 'Submit'
  element :next_section_button, :xpath, "//button[text()='Next Section']"
  element :case_closed_dialogue, :xpath, "//div[@role='alertdialog']//span[text()='Case Closed successfully']"

  # Retention case
  element :credit_impact_termination_reason_radio_button, :xpath, "//input[@value='Credit Impact']"
  element :termination_next_step_dropdown, :xpath, "//*[@data-id='terminationStep']//span[text()='Select an Option']"
  element :termination_next_step_dropdown_selection, :xpath, "//*[@title='Bankruptcy']"
  element :request_channel_dropdown, :xpath, "//*[@class='slds-form-element']//span[text()='Select channel']"
  element :request_channel_dropdown_selection, :xpath, "//span[@title='SMS']"
  element :contact_status_dropdown, :xpath, "//*[@class='slds-form-element']//span[text()='Select contact Status']"
  element :contact_status_dropdown_selection, :xpath, "//span[@title='Closed with contact']"
  element :reason_for_program_saved_dropdown, :xpath, "//span[text()='Select Reason']"
  element :reason_for_program_saved_dropdown_selection, :xpath, "//span[text()='Defer Deposit']"
  element :saved_program_description, :xpath, "//span[text()='Select Description']"
  element :saved_program_description_selection, :xpath, "//span[text()='1 month']"
  element :type_section, :xpath, "//label[text()='Type']/.."
  element :close_all_tabs_tab, :xpath, "//span[text()='Close All Tabs']"
  element :close_tabs_button, :xpath, "//*[text()='Close Tabs']"

  def tradeline_from_grid(tradeline)
    tradeline_grid.rows.find { |row| row.tradeline_name.text == tradeline }
  end

  def close_case(case_status:)
    close_case_button.click
    select_closed_stage.click
    find(:xpath, "//span[text()='#{case_status}']").click
    close_case_submit_button.click
  end

  def close_set_status(status)
    wait_until_close_status_dropdown_visible(wait: 5)
    close_status_dropdown.set status
    click_button('Submit')
  end

  def mark_tradeline_legal(tradeline, legal_status, legal_source, collection_agency, hearing_date)
    select_tradeline.set(tradeline)
    legal_status_dropdown.set legal_status
    legal_service_dropdown.set legal_source
    collection_agency_input.set collection_agency
    legal_hearing_date.fill_by_date(hearing_date)
    click_button("Mark #{tradeline} as Legal")
  end

  def retention_case
    credit_impact_termination_reason_radio_button.click
    termination_next_step_dropdown.click
    termination_next_step_dropdown_selection.click
    request_channel_dropdown.click
    request_channel_dropdown_selection.click
    contact_status_dropdown.click
    contact_status_dropdown_selection.click
    click_button('Save Termination Reason')
    click_button('Saved Program')
    reason_for_program_saved_dropdown.click
    reason_for_program_saved_dropdown_selection.click
    saved_program_description.click
    saved_program_description_selection.click
    click_button('Save')
  end
end
