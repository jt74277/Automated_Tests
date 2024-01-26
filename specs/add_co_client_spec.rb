# frozen_string_literal: true

require 'spec_helper'

RSpec.feature 'Add Co-Client Case' do
  let(:case_page)               { CasePage.new }
  let(:co_client_case_page)     { CoClientCasePage.new }
  let(:glue_api)                { GlueAPI.new }
  let(:test_data)               { glue_api.create_data('qa_program', 'pre_settlement_tradelines_ready_for_offer') }
  let(:sfid)                    { test_data['sfid'] }

  scenario 'Add Co-Client case Happy Path E2E' do
    navigate_to_program_by_sfid(sfid, app: 'CX360', login_as: 'servicecloud')
    create_case(type: 'Add Co-Client', related_contact: :first)
    wait_for_salesforce_page_load

    co_client_case_page.fill_out_co_client_form
    co_client_case_page.create_co_client_button.click
    wait_for_popup('Co-Client is created succesfully')
    co_client_case_page.next_section_button.click
    co_client_case_page.generate_ea_button.click
    wait_for_salesforce_page_load
    sleep 1 # Sometimes click happens before page is loaded
    co_client_case_page.clear_error_modal_button.click if co_client_case_page.clear_error_modal_button.visible?
    co_client_case_page.send_ea_button.click
    wait_for_popup('The EA has been sent successfully.')
    co_client_case_page.next_section_button.click
    sleep 2 # Sometimes click happens before page is loaded
    co_client_case_page.close_case(case_status: 'Complete')
    wait_for_popup('Case closed successfully')

    expect(co_client_case_page.case_status_complete).to be_visible
  end
end
