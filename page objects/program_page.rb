# frozen_string_literal: true

class ProgramPage < SfBasePage
  include RSpec::Matchers

  set_url 'lightning/r/Program__c/{sfid}/view'
  set_url_matcher 'lightning/r/Program__c/.*/view'

  element :related_tab, :xpath, "//*[@id='relatedListsTab__item']"
  element :details_tab, :xpath, "//*[@id='detailTab__item']"

  element :program_history, :xpath, "//span[@title='Program History']"
  element :bank_accounts, :xpath, "//span[@title='Bank Accounts']"
  elements :bank_account_statuses, :xpath, "//td[@data-label='Status']"
  element :bank_account_name, :xpath, "//a/slot/slot/span[contains(text(), 'BA')]"
  element :trust_account, :xpath, "//lightning-primitive-cell-factory[@data-label='Trust Account Name']//lightning-primitive-custom-cell"

  element :program_tradelines, :xpath, "//span[@title='Program Tradelines']"
  elements :tradeline_names, :xpath, "//th[@data-label='Tradeline Name']//a//span"

  element :new_case_button, :xpath, "//button[text()='Create Case']"

  element :case_type_selector, :xpath, "//button[@name='CaseType']"
  section :related_contacts, DropboxComponent, :xpath, "//button[@name='Related Contacts']"
  element :case_close_button, :xpath, "//button[@title='Close this window']"
  element :case_type_option, :xpath, '//lightning-base-combobox-item'

  elements :option, :xpath, '//option'

  element :next_button, :xpath, "//button[text()='Next']"
  element :edit_tradeline, :xpath, '(//table[1]/tbody[1]/tr[1]/td[4])[3]'

  element :edit, :xpath, "//a[@title='Edit']"
  element :delete_btn, :xpath, "//a[@title='Delete']"

  elements :headers, :xpath, '//lst-common-list-internal', minimum: 2, wait: 30

  section :service_entity_dropdown, DropboxComponent, :xpath, "//label[contains(text(), 'Service Entity Code')]/../div//button"
  element :save_button, :xpath, "//button[@name='SaveEdit']"

  section :consultation_call_checkbox, CheckboxComponent, :xpath, "//input[contains(@name, 'Consultation_Call_Complete')]"

  element :new_loan_button, :xpath, "//li[contains(@data-target-selection-name, 'Program_Loan__c')]"

  elements :transaction_name_rows, :xpath, "//th[@data-label='Transaction Name']"

  element :more_tab, :xpath, "//button[contains(@title, 'More Tabs')]"
  element :program_event_menu, :xpath, "//span[contains(text(), 'Program Event')]"
  element :program_event_tab, :xpath, "//a[contains(text(), 'Program Event')]"
  element :first_event_link, :xpath, "(//table[contains(@aria-label, 'Program Events')]//a//span)[1]"

  # Client Details
  element :email_address, :xpath, ".//lightning-input-field[@data-id='email']"
  element :home_phone, :xpath, ".//lightning-input[@data-id='HomePhone']"
  element :mobile_phone, :xpath, ".//lightning-input[@data-id='MobilePhone']"

  # Cases
  elements :case_types, :xpath, "(//table[@aria-label='Cases']//td[2]//span[@title])"
  elements :case_statuses, :xpath, "(//table[@aria-label='Cases']//td[3]//span[@title])"

  section :cases_table, :xpath, "//*[@data-target-selection-name='lst_dynamicRelatedList']//table" do
    sections :rows, :xpath, './tbody/tr' do
      element  :case_number_link, :xpath, './/th[1]//a//span'
      element  :case_type, :xpath, './/td[2]//div'
    end
  end

  def get_case_link_by_type(input_case_type)
    cases_table.rows.each_with_index do |row, i|
      return i if row.case_type.text == input_case_type
    end
    raise "'#{input_case_type}' not found"
  end

  def sfid
    URI.parse(current_url).request_uri.split('/')[4]
  end

  def click_new_for(section_name)
    headers.find { |h| h.text.include? section_name }.find_button('New').click
  end

  def delete_program_loans
    scroll_to_element { program_loan_section }
    loans = program_loan_section.all(:xpath, './/tr/td[last()]', wait: 2)
    loans.each do |loan|
      loan.click
      delete_record
    end
  end

  def delete_record
    delete_btn.click
    click_button('Delete')
    sleep 2
  end

  def program_loan_section
    headers.find { |h| h.text.include? 'Program Loan' }
  end

  def go_to_related_tab
    wait_until_related_tab_visible
    related_tab.click
    wait_until_program_history_visible
    has_content?('Account Number')
  end

  def go_to_tradeline(index = 1)
    scroll_to_element { program_tradelines }
    tradeline_names[index].click
    has_field?('Enrolled Balance', with: %r{\$})
  end

  def add_funded_loan
    new_loan_button.click
    loan_modal = NewProgramLoanModal.new
    loan_modal.create_new_funded_loan
  end

  def navigate_to_first_event_page
    if has_more_tab?
      more_tab.click
      program_event_menu.click
    else
      program_event_tab.click
    end
    first_event_link.click
  end

  # Assert a Change Program Deposits and a Bank Account case are created
  def assert_case_status
    case_types_text = case_types.map(&:text)
    case_statuses_text = case_statuses.map(&:text)
    case_types_text.each_with_index do |case_type, id|
      case case_type
      when 'Bank Account' || 'Change Program Deposits'
        expect(case_statuses_text[id]).to eq 'New'
      when 'Onboarding Call'
        expect(case_statuses_text[id]).to eq 'Complete'
      end
    end
  end
end

class NewProgramLoanModal < SfBasePage
  section :loan_application_status_dropdown, DropboxComponent, :xpath, "//button[contains(@aria-label, 'Loan Application Status')]"
  def create_new_funded_loan
    loan_application_status_dropdown.set 'Funded'
    click_button('Save')
  end
end
