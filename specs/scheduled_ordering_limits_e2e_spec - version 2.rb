# frozen_string_literal: true

require_relative “scheduled_ordering_e2e_shared_examples"

feature "Scheduled Ordering Limits e2e flow", :desktop_only, :main_and_embedded, :focus, :headed do
  let(:enabled)      { {enabled: true, paymentTypes: {cash: true}} }
  let(:menu_context) { |example| example.metadata[:menu_context] }
#  let(:admin)        { create(:user, :dispensary_admin, profile_attributes: {dispensaryId: dispensary._id}) }
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

  context "Admin" do
    let(:admin) do
      create(:user, :dispensary_admin, profile_attributes: {dispensaryId: dispensary._id})
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
  
      include_examples "Scheduled Ordering + Order Limits for pickup order types", testrail_id: 491871
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
  
      include_examples "Scheduled Ordering + Order Limits for pickup order types", testrail_id: 491875
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
  
      include_examples "Scheduled Ordering + Order Limits for pickup order types", testrail_id: 491876
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
  
      include_examples "Scheduled Ordering + Order Limits for delivery order types", testrail_id: 491872
    end
  end
