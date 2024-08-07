# frozen_string_literal: true

def_shared_example "Scheduled Ordering + Order Limits for all order types" do
  # Given that dispensary admin is logged in
  settings.login_as admin
  byebug
  # And Settings page is loaded
  settings.load(dispensary: dispensary._id, tab: "settings")

  # And I click the Ordering tab
  settings.subheader.tab(text: "Ordering").click

  # And I click on an ordering option
  settings.order_type.order_type_link(text: ordertype).click

  # And I enable Scheduled Ordering
  settings.ordering.pickup.ordering_options.scheduled_ordering_option.click

  # And I select 30 mins each for the pickup time slot
  settings.ordering.pickup.ordering_options.time_slots.select("30 minutes each")

  # And I set the next available to 10 minutes
  settings.ordering.pickup.ordering_options.next_available_time.select("10 minutes")

  # And I enable Order Limits
  settings.ordering.pickup.ordering_options.order_limits.toggle.click

  # And I set the order limit to 1 for the 11-11:30pm slot
  settings.ordering.pickup.ordering_options.order_limits.order_limit_time_slot(text: "11:00pm - 11:30pm").fill_in with:"1"

  # And I click publish
  settings.publish_button.click

  # Then a green banner flashes saying you successfully updated the settings
  settings.has_ernie?

  # When I navigate to the dispensaries menu on consumer
  menu.load(dispensary: dispensary, area: "products", sub_area: "flower")

  # And add a product to the cart
  menu.products.listed_product(match: :first).add_button.click

  # And I select the order type on the Order Type Modal for embedded menu
  if menu_context == :embedded and fulfillment == "Delivery"
    menu.order_type_modal.order_type(text: "Delivery").click
    menu.address_modal.save_address
    menu.residence_modal.yes_residence.click
  elsif menu_context == :embedded and fulfillment == "Pickup"
      menu.order_type_modal.order_type(text: "Pickup").click
  end

  # And I click the button to go to checkout
  menu.cart_pane.proceed_to_checkout.click

  # Then I am navigated to the checkout page
  expect(checkout).to be_loaded

  # When I enter Customer info
  checkout.checkout_form.enter_customer_information
  wait_for_render
  fullname = checkout.checkout_form.fname.value + " " + checkout.checkout_form.lname.value

  # And I select the order type
  if menu_context == :main and fulfillment == "Delivery" 
    checkout.type.order_type_radio_button(text: type).click
    checkout.checkout_form.delivery_address.fill_in with: "40 NE 3rd St, Bend, OR 97701"
    wait_for_render
    checkout.google_suggestion_form.address_suggestion.click
    menu.residence_modal.yes_residence.click
    checkout.type.save_button.click
  elsif fulfillment == "Pickup"
      checkout.type.order_type_radio_button(text: type).click
      checkout.type.save_button.click
  end

  # Then the time section is visible
  expect(checkout.time).to be_loaded

  # When I select Cash as payment type
  # And I select Scheduled for Later
  checkout.time.scheduled_for_later_radio_button.click

  # And I select 11-11:30 time slot for today
  checkout.time.scheduled_day.click
  checkout.time.scheduled_day_option(text: "Today").click
  checkout.time.scheduled_time.click
  checkout.time.scheduled_time_option(text: "11pm - 11:30pm").click

  # And I click to to complete the order
  checkout.order_overview.place_order.click

  # Then the guest success modal appears
  expect(checkout.success_modal).to be_present

  # When I click No thanks on the guess success modal
  checkout.success_modal.dont_save_button.click

  # And I navigate to the dispensaries menu on consumer
  menu.load(dispensary: dispensary, area: "products", sub_area: "flower")

  # And I add another product to the cart
  menu.products.listed_product(match: :first).add_button.click

  # And I select the order type on the Order Type Modal for embedded menu
  if menu_context == :embedded and fulfillment == "Delivery"
    menu.order_type_modal.order_type(text: "Delivery").click
  elsif menu_context == :embedded and fulfillment == "Pickup"
      menu.order_type_modal.order_type(text: "Pickup").click
  end

  # And I click the button to go to checkout
  menu.cart_pane.proceed_to_checkout.click

  # Then I am navigated to the checkout page
  expect(checkout).to be_loaded

  # When I enter Customer info
  checkout.checkout_form.enter_customer_information

  # And I select the order type
  if menu_context == :main and fulfillment == "Delivery"
    checkout.type.order_type_radio_button(text: type).click
  elsif fulfillment == "Pickup"
      checkout.type.order_type_radio_button(text: type).click
      checkout.type.save_button.click
  end

  # Then the time section is visible
  expect(checkout.time).to be_loaded

  # When I select Cash as payment type
  # And I select Scheduled for Later
  checkout.time.scheduled_for_later_radio_button.click

  # And I attempt to select 11-11:30 time slot for today
  checkout.time.scheduled_day.click
  checkout.time.scheduled_day_option(text: "Today").click
  checkout.time.scheduled_time.click

  # Then the 11-11:30 pickup/delivery slot is no longer available
  expect(checkout.time.scheduled_time_option(text: "11pm - 11:30pm (Sold out)")).to be_present

  # When I navigate to the dispensary admin orders page
  # wait_for_render
  orders.load(dispensary: dispensary._id)

  # Then the order is present
  expect(orders.active_order_card.customer_name[0].text).to eq(fullname)

  # And the pickup/delivery time slot is present in the order tile
  expect(orders.active_order_card.scheduled_day).to be_present
  expect(orders.active_order_card.scheduled_time).to be_present

  # When I click the confirm button
  orders.active_order_card.confirm_button(text: "CONFIRM").click

  # Then the Start Delivery button appears
  if fulfillment == "Delivery"
    expect(orders.active_order_card.fulfillment_button(text: "START DELIVERY")).to be_present
  # When I click the Start Delivery button
    orders.active_order_card.fulfillment_button(text: "START DELIVERY").click
  # Then the Select Driver modal appears
    expect(orders.select_driver_modal).to be_present
 
  # When I select a driver and click Continue
    orders.select_driver_modal.driver_dropdown.click
    orders.select_driver_modal.driver_option(match: :second).click
    orders.select_driver_modal.continue_button.click
  # Then the Close Order button appears
    expect(orders.active_order_card.fulfillment_button(text: "CLOSE ORDER"))
  # When I click the Close Order button
    orders.active_order_card.fulfillment_button(text: "CLOSE ORDER").click
  else
  # Then the Ready for Pickup button appears
    expect(orders.active_order_card.fulfillment_button(text: "READY FOR PICKUP")).to be_present
  # When I click the Ready for Pickup button
    orders.active_order_card.fulfillment_button(text: "READY FOR PICKUP").click
  end

  # Then the order disappears from the current orders page
  # And is listed under Past orders
  orders.click_link(text: "Past")
  expect(orders.past_orders.customer_name.text).to eq(fullname)
end

feature "Scheduled Ordering Limits e2e flow", :desktop_only, :main_and_embedded, :focus, :headed do
  let(:enabled)      { {enabled: true, paymentTypes: {cash: true}} }
  let(:menu_context) { |example| example.metadata[:menu_context] }
  let(:admin)        { create(:user, :dispensary_admin, profile_attributes: {dispensaryId: dispensary._id}) }
  let(:settings)     { AdminSettings::Page.new }
  let(:orders)       { AdminDispensaryOrders::Page.new }
  let(:checkout)     { Checkout::Page.new }
  let!(:dispensary) do
    create(
      :dispensary_with_products,
      profile_attributes: {
        featureFlags:       {enableArrivals: true},
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

  context "In Store Pickup" do
    let(:ordertype) { "In-Store Pickup" }
    let(:fulfillment) { "Pickup" }
    let(:type) { "Pickup(In-Store)" }
    let(:menu) do
      if menu_context == :main
        Dispensary::DesktopMain::Page.new
      else
        Dispensary::DesktopEmbedded::Page.new
      end
    end

    include_examples "Scheduled Ordering + Order Limits for all order types", testrail_id: 491871
  end

  context "Curbside Pickup" do
    let(:ordertype) { "Curbside Pickup" }
    let(:fulfillment) { "Pickup" }
    let(:type) { "Pickup(Curbside)" }
    let(:menu) do
      if menu_context == :main
        Dispensary::DesktopMain::Page.new
      else
        Dispensary::DesktopEmbedded::Page.new
      end
    end

    include_examples "Scheduled Ordering + Order Limits for all order types", testrail_id: 491875
  end

  context "Drive-Thru Pickup" do
    let(:ordertype) { "Drive-Thru Pickup" }
    let(:fulfillment) { "Pickup" }
    let(:type) { "Pickup(Drive thru)" }
    let(:menu) do
      if menu_context == :main
        Dispensary::DesktopMain::Page.new
      else
        Dispensary::DesktopEmbedded::Page.new
      end
    end

    include_examples "Scheduled Ordering + Order Limits for all order types", testrail_id: 491876
  end

  context "Delivery" do
    let(:ordertype) { "Delivery" }
    let(:fulfillment) { "Delivery" }
    let(:type) { "Delivery" }
    let(:menu) do
      if menu_context == :main
        Dispensary::DesktopMain::Page.new
      else
        Dispensary::DesktopEmbedded::Page.new
      end
    end

    include_examples "Scheduled Ordering + Order Limits for all order types", testrail_id: 491872
  end
end
