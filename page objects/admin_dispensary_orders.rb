# frozen_string_literal: true

require_relative "../base"
require_relative "./admin"
require_relative "./admin_frame"

module AdminDispensaryOrders
  class ActiveOrderCard < SitePrism::Section
    set_default_search_arguments :data_cy, "active-order-card"

    element :active_order_card, :data_cy, "active-order-card"
    element :delivery_type, :data_cy, "delivery-type"
    element :pickup_day, :data_cy, "pickup-day"
    element :pickup_time, :data_cy, "pickup-time"
    elements :customer_name, :class_match, "active-order-card__CustomerNameText"
  end

  class CurrentTab < SitePrism::Section
    set_default_search_arguments :class_match, "content-container__InnerContainer"

    sections :order_cards, ActiveOrderCard
  end

  class EditOrder < SitePrism::Section
    set_default_search_arguments :class_match, "individual-order__OrderContainer"

    element :delivery_type, :data_cy, "order-details-delivery-type"
    element :pickup_time, :data_cy, "order-details-pickup-time"
    element :edit_order_link, :class_match, "header__InlineAction", text: "Edit Order"
    element :print_order_button, :class_match, "sub-footer__PrintButton"
  end

  class Page < BasePage
    extend Admin
    set_url "#{base_url}/dispensaries/{dispensary}/orders{/tab}"

    section :subheader, AdminFrame::Subheader
    section :header, AdminFrame::Header
    section :active_order_card, ActiveOrderCard
    section :current_tab, CurrentTab
    section :edit_order, EditOrder

    def scheduled_order_date(order)
      order_day = order[:reservation][:startTimeISO].to_date.day
      order_month = order[:reservation][:startTimeISO].to_date.month
      order_day - pst_time_now.day == 1 ? "Tomorrow" : "#{order_month}/#{order_day}"
    end

    def load_dispensary_orders_page(dispensary_id)
      retries ||= 0
      self.load(dispensary: dispensary_id, tab: "current")
      current_tab.wait_until_order_cards_visible(wait: 20)
    rescue Capybara::ElementNotFound
      retry if (retries += 1) < 3
      raise Capybara::ElementNotFound
    end
  end
end

