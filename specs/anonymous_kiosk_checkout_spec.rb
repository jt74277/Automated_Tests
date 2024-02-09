# frozen_string_literal: true

feature "Anonymous Kiosk Orders", :desktop_only do
  let(:enabled) { {enabled: true, paymentTypes: {cash: true}} }
  let!(:dispensary) do
    create(
      :dispensary_with_products,
      _id:                "E2EAnonKioskDispo",
      profile_attributes: {
        order_types_config: {
          pickup:          enabled,
          curbsidePickup:  enabled,
          driveThruPickup: enabled,
          delivery:        enabled,
          kiosk:           enabled
        }
      }
    )
  end

  let(:admin)    { create(:user, :dispensary_admin, profile_attributes: {dispensaryId: dispensary._id}) }
  let(:settings) { AdminSettings::Page.new }
  let(:orders)   { AdminDispensaryOrders::Page.new }
  let(:kiosk)    { Dispensary::Kiosk::Page.new }

  before do
    # Given the anonymous-kiosk-checkout LD flag is enabled for the dispensary
    # And I am logged in as a Dispensary Admin
    settings.login_as admin

    # And I navigate to the Settings > Ordering > Kiosk page
    settings.load(dispensary: dispensary._id, tab: "settings")
    settings.subheader.tab(text: "Ordering").click
    settings.order_type.order_type_link(text: "Kiosk").click

    # And Kiosk Mode is enabled
    expect(settings.ordering.kiosk.mode).to be_enabled

    # And all Kiosk options are disabled
    expect(settings.ordering.kiosk.kiosk_options.full_name_only_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.hide_phone_field_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.phone_required_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.hide_email_field_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.show_notes_field_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.show_birthdate_field_checkbox).not_to be_checked
    expect(settings.ordering.kiosk.kiosk_options.enable_directed_orders_checkbox).not_to be_checked
  end

  after do
    # And I add a product to the cart
    kiosk.products.listed_product(match: :first).add_button.click

    # And I click Proceed to Checkout
    kiosk.cart_pane.proceed_to_checkout.click

    # And I click the Anonymous Checkout checkbox
    kiosk.kiosk_checkout_modal.anonymous_checkout.click

    # Then the First Name field is hidden
    # And the Last Name field is hidden
    # And the Phone field is hidden
    # And the Email field is hidden
    # And the Birthday field is hidden
    expect(kiosk.kiosk_checkout_modal).to have_no_input_field

    # And I submit the Order
    kiosk.kiosk_checkout_modal.submit_order_button.click

    # Then the Order is submitted successfully
    expect(kiosk.kiosk_order_submitted_modal).to have_content("Order Submitted!")

    # And the Order Submitted modal is displayed
    expect(kiosk.kiosk_order_submitted_modal).to be_present

    # And the Order number is displayed in the modal
    order_num_string = kiosk.kiosk_order_submitted_modal.order_number.text
    order_num = order_num_string.split(":").last.strip
    expect(kiosk.kiosk_order_submitted_modal).to have_content("Your order number is: #{order_num}")

    # When I navigate to the Orders page
    wait_for_render
    orders.load(dispensary: dispensary._id)

    # Then the name on the order is "Anonymous <order id>"
    expect(orders.active_order_card.customer_name[0].text).to eq("Anonymous")
    expect(orders.active_order_card.customer_name[1].text).to eq(order_num)
  end

  scenario "E2E Anonymous Kiosk Order with no Kiosk options enabled", testrail_id: 491445 do
    # When I navigate to the Kiosk Consumer page for the dispensary
    kiosk.load(dispensary: dispensary, area: "products", sub_area: "flower")
  end

  scenario "E2E Anonymous Kiosk Order with some Kiosk options enabled", testrail_id: 508708 do
    # And I enable Phone Required and Show Birthday Field options
    settings.ordering.kiosk.kiosk_options.phone_required_checkbox.click
    settings.ordering.kiosk.kiosk_options.show_birthdate_field_checkbox.click

    # And the changes are published
    settings.publish_button.click

    # When I navigate to the Kiosk page for the dispensary
    kiosk.load(dispensary: dispensary, area: "products", sub_area: "flower")
  end
end
