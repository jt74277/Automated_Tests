# frozen_string_literal: true

require_relative "../base"
require_relative "./admin"
require_relative "./admin_frame"

# Admin settings pages
module AdminSettings
  SECTION_CONTAINER = "styles__SettingsFieldContainer"
  private_constant :SECTION_CONTAINER
  OUTER_CONTAINER = "content-container__OuterContainer"
  private_constant :OUTER_CONTAINER

  # Store Info tab
  class StoreInfo < SitePrism::Section
    set_default_search_arguments :class_match, OUTER_CONTAINER

    element :address_field, "pac-target-input"
  end

  module Toggle
    include SitePrism::DSL
    element :toggle, :class_match, "active-switch__Switch"

    # Matchers
    def disabled?
      has_text? "DISABLED"
    end

    def enabled?
      has_text? "ENABLED"
    end
  end

  module TextField
    include SitePrism::DSL
    element :text_field, :class_match, "form-field-wrappers__StyledTextArea"
  end

  # Ordering Options area of order type subsection
  class OrderingOptions < SitePrism::Section
    set_default_search_arguments :class_match, SECTION_CONTAINER, text: "Ordering Options"

    section :advanced_ordering, :class_match, SECTION_CONTAINER, text: "Advanced Ordering" do
      element :toggle, :data_test, "advanced-day-enabled-switch"
      element :dropdown, :data_test, "advanced-day-ordering-select"
    end

    section :order_limits, :class_match, SECTION_CONTAINER, text: "Order Limits" do
      include Toggle
    end

    # Visible checkbox option elements for clicking on
    element :asap_ordering_option, :data_test, "asap-ordering-checkbox"
    element :scheduled_ordering_option, :data_test, "scheduled-ordering-checkbox"
    # Locates the actual checkbox elements so that we can call #checked? against them
    element :asap_ordering_checkbox, :data_test, "asap-ordering-checkbox", visible: :hidden
    element :scheduled_ordering_checkbox, :data_test, "scheduled-ordering-checkbox", visible: :hidden

    element :scheduled_ordering_bar, :class_match, "expandable-option-box__HeaderButtonText"
    element :time_slots, :data_test, "scheduled-ordering-times-slots"
    element :next_available_time, :data_test, "next-available-time-select"

    def has_selected_time_slot?(option)
      time_slots.find("option", text: option, exact_text: true).selected?
    end

    def has_selected_next_available_time?(option)
      next_available_time.find("option", text: option, exact_text: true).selected?
    end
  end

  # Subsection (e.g. Delivery or Pickup) on the Ordering tab.
  class OrderingSubTab < SitePrism::Section
    set_default_search_arguments :class_match, "tabs__TabFormContainer"

    section :payment_types, :class_match, SECTION_CONTAINER, text: "Payment Types" do
      # this is hacky but seems like the best way to handle these divs with hidden checkboxes? If this becomes a
      # pattern we see a lot, we may need to make a module out of it
      section :type, :class_match, "checkbox-old__CheckboxLabel" do
        element :checkbox, :class_match, "checkbox-old__StyledCheckbox", visible: :hidden

        # if we end up needing more methods like this to refer to root elements, we may need a delegation scheme using
        # method_missing
        def click
          root_element.click
        end
      end
    end

    element :title, :class_match, "tabs__Title"
  end

  # Ordering subtabs dealing with delivery and various pickup type settings
  class PickupAndDelivery < OrderingSubTab
    section :ordering_options, OrderingOptions
    section :after_hours_ordering, :class_match, SECTION_CONTAINER, text: "After Hours Ordering" do
      include Toggle
    end
    section :pickup_minimum, :class_match, SECTION_CONTAINER, text: "Pickup Minimum" do
      include Toggle
      element :field, :input, "inStorePickup.orderMinimum.minimumInCents"
      element :drive_thru_field, :input, "driveThruPickup.orderMinimum.minimumInCents"
    end
    section :after_hours_ordering, :class_match, SECTION_CONTAINER, text: "After Hours Ordering" do
      include Toggle
    end
    section :zip_code, :class_match, "delivery-options__StyledSettingsFieldContainer", text: "Zip Codes" do
      sections :row_num, :class_match, "tables__Tr" do
        elements :x_button, :class_match, "tables__CloseIcon"
        elements :zip_code_link, :class_match, "tables__TableLink"
      end
    end
    element :delivery_min, :input, "delivery.deliveryRadius.orderMinimum.minimumInCents"
    element :delivery_area, "select[name='delivery.deliveryMode']"
    element :find_zone, :class_match, "link__StyledLink", text: "+ Add Zone"
    element :zip_code_link, :class_match, "link__StyledLink", text: "+ Add Zip Code"
    element :asap_ordering, :class_match, "checkbox-old__CheckboxLabel", text: "ASAP Ordering"
    element :scheduled_ordering, :class_match, "checkbox-old__CheckboxLabel", text: "Scheduled Ordering"
    element :scheduled_ordering_options_link, :class_match, "expandable-option-box", text: "Options"
    element :cash_checkbox, :class_match, "checkbox-old__CheckboxLabel", text: "Cash"
    element :debit_checkbox, :class_match, "checkbox-old__CheckboxLabel", text: "Debit"
    element :payment_checkboxes, :class_match, "checkbox-old__CheckboxLabel"
    element :add_delivery_fee_link, :class_match, "link__StyledLink", text: "Add a delivery fee"
    element :edit_delivery_fees_link, :class_match, "link__StyledLink", text: "Edit delivery fees"
  end

  class ZipCodeModal < SitePrism::Section
    set_default_search_arguments(:class_match, "ReactModal__Content", text: "Add Zip Code")

    element :zip_code, :input, "zipCode"
    element :delivery_fee, :input, "feeInCents"
    element :delivery_min, :input, "minimum-in-cents"
  end

  class DeliveryZoneModal < SitePrism::Section
    set_default_search_arguments(:class_match, "ReactModal__Content", text: "Add Delivery Zone")

    element :zone_name, :input, "name"
    element :draw_zone, :class_match, "edit-delivery-zone-modal__DropzoneContainer"
    element :delivery_fee, :input, "feeInCents"
    element :delivery_min, :input, "minimumInCents"
  end

  # Curbside pickup ordering subtab
  class CurbsidePickup < PickupAndDelivery
    section :curbside_arrivals, :class_match, SECTION_CONTAINER, text: "Curbside Arrivals" do
      include Toggle
    end
    section :arrival_instructions, :class_match, SECTION_CONTAINER, text: "Arrival Instructions" do
      include TextField
    end
    section :after_hours_ordering, :class_match, SECTION_CONTAINER, text: "After Hours Ordering" do
      include Toggle
    end
    section :pickup_minimum, :class_match, SECTION_CONTAINER, text: "Pickup Minimum" do
      include Toggle
      element :field, :input, "curbsidePickup.orderMinimum.minimumInCents"
    end
  end

  # Ordering subtab dealing with Kiosk settings
  class Kiosk < OrderingSubTab
    section :mode, :class_match, SECTION_CONTAINER, text: "Kiosk Mode" do
      include Toggle
    end
    section :instructions, :class_match, SECTION_CONTAINER, text: "Kiosk Instructions" do
      include TextField
    end

    element :kiosk_url, :input, "kioskURL"

    section :kiosk_options, :class_match, SECTION_CONTAINER, text: "Kiosk Options" do
      element :full_name_only_checkbox, :input, "kiosk.fullNameOnly", visible: :hidden
      element :hide_phone_field_checkbox, :input, "kiosk.hidePhoneField", visible: :hidden
      element :phone_required_checkbox, :input, "kiosk.phoneRequired", visible: :hidden
      element :hide_email_field_checkbox, :input, "kiosk.hideEmailField", visible: :hidden
      element :show_notes_field_checkbox, :input, "kiosk.notesField", visible: :hidden
      element :show_birthdate_field_checkbox, :input, "kiosk.showBirthdateField", visible: :hidden
      element :enable_directed_orders_checkbox, :input, "kiosk.directedOrders", visible: :hidden
    end
  end

  # Order Type
  class OrderType < SitePrism::Section
    set_default_search_arguments :class_match, "tabs__TabContainer"

    element :order_type_link, :class_match, "MuiButtonBase-root"
  end

  # Ordering tab
  class Ordering < SitePrism::Section
    set_default_search_arguments :class_match, OUTER_CONTAINER

    section :delivery, PickupAndDelivery
    section :kiosk, Kiosk
    section :in_store_pickup, PickupAndDelivery
    section :curbside_pickup, CurbsidePickup
    section :drive_thru_pickup, PickupAndDelivery
  end

  # Hours tab
  class Hours < SitePrism::Section
    set_default_search_arguments :class_match, OUTER_CONTAINER

    section :ordering_hours, :class_match, SECTION_CONTAINER, text: "Ordering Hours" do
      element :type_dropdown, :data_cy, "hours-type-select"
    end
    section :current_hours, :class_match, SECTION_CONTAINER, text: "Sunday" do
      element :edit_hours_link, :class_match, "link__StyledLink"
    end
    section :special_hours, :class_match, SECTION_CONTAINER, text: "Special Hours" do
      element :add_special_hours_link, :data_cy, "add-special-hours-link"
      element :edit_special_hours_link, :class_match, "link__StyledLink", text: "Edit"
    end

    expected_elements :ordering_hours, :current_hours
  end

  class SpecialHoursModal < SitePrism::Section
    set_default_search_arguments(:class_match, "ReactModal__Content", text: "Edit Special Hours")

    element :special_name, :input, "name"
    element :three_dots, :class_match, "day-control__IconPopButtonContainer"
    element :all_day, :class_match, "day-control__PopButton"
    element :special_time, :class_match, "day-control__StatusBox"
    element :save_hours, :data_cy, "special-hours-save-button"
    element :ending_date, :input, "range-end-date"
    element :current_starting_date, :input, "range-start-date"

    # Actions
    def edit_special_hours_name(rename_special)
      special_name.fill_in with: rename_special, fill_options: {clear: :backspace}
    end
  end

  class Calendar < SitePrism::Section
    set_default_search_arguments(:class_match, "ReactModal__Content", match: :prefer_exact)
    elements :days, :class_match, "CalendarDay__default_2", match: :prefer_exact

    def select_new_day
      day = days.find {|day| day.text == Date.tomorrow.strftime("%-d").to_s }

      # For start day
      day.click
      # For end day
      day.click
    end
  end

  # Line for a day in the order hours modal
  class OrderHoursModalDayLine < SitePrism::Section
    element :mode_select_button, :class_match, "day-control__IconPopButtonContainer"
    element :active_checkbox, :class_match, "checkbox-old__StyledCheckbox", visible: :hidden, match: :first
    elements :hours_selectors, :class_match, "select__StyledSelect", count: 2
    element :all_day_selection, :class_match, "day-control__StatusBox"

    expected_elements :mode_select_button, :active_checkbox

    # The only way to find these is by index, so grab them from the hours_selectors element array
    def open_time_dropdown
      hours_selectors[0]
    end

    def close_time_dropdown
      hours_selectors[1]
    end

    # Actions
    def update_open_close_times(open_time, close_time)
      open_time_dropdown.select(open_time)
      close_time_dropdown.select(close_time)
    end

    # Matchers
    def active?
      active_checkbox.checked?
    end
  end

  # Modal for setting ordering hours - opens from Hours tab
  class OrderHoursModal < SitePrism::Section
    DAY_LINE_CLASS = "day-control__StyledElementContainer"
    private_constant :DAY_LINE_CLASS

    set_default_search_arguments :class_match, "ReactModal__Content"

    sections :days_of_week, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, count: 7
    section :sunday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Sunday"
    section :monday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Monday"
    section :tuesday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Tuesday"
    section :wednesday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Wednesday"
    section :thursday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Thursday"
    section :friday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Friday"
    section :saturday, OrderHoursModalDayLine, :class_match, DAY_LINE_CLASS, text: "Saturday"

    element :save_hours_button, :class_match, "button__StyledButton", text: "SAVE HOURS"

    # Matchers
    def has_all_days_active?
      days_of_week.all?(&:active?)
    end
  end

  class Page < BasePage
    extend Admin
    set_url "#{base_url}/dispensaries/{dispensary}/settings/{tab}{/sub_tab}"

    section :subheader, AdminFrame::Subheader
    section :header, AdminFrame::Header
    section :store_info, StoreInfo
    section :ordering, Ordering
    section :order_type, OrderType
    section :hours, Hours
    section :order_hours_modal, OrderHoursModal
    section :delivery_zone_modal, DeliveryZoneModal
    section :zip_code_modal, ZipCodeModal
    section :special_hours_modal, SpecialHoursModal
    section :calendar, Calendar
    section :pickup_and_delivery, PickupAndDelivery
    section :curbside_pickup, CurbsidePickup
    section :kiosk, Kiosk

    element :sub_tab_selector, :class_match, "MuiTab-wrapper"

    # Pops up on Hours tab but outside the section element
    element :change_hours_mode_popup, :class_match, "day-control__PopButton"
    # Pops up within different tabs but is identical in each one
    element :publish_button, :class_match, "changes-bar__StyledButton"

    # Matchers
    def has_success_ernie?(setting:)
      has_ernie? "Your #{setting} settings have been updated!", "success"
    end

    def has_bold_header?(header)
      find(:class_match, "link__Label", text: header).matches_style?("font-weight": "700")
    end

    def has_bold_link?(link)
      find(:class_match, "MuiTab-root", text: link).matches_style?("font-weight": "700")
    end

    def has_common_settings?
      find(:class_match, "checkbox-old__CheckboxLabel", text: "ASAP Ordering")
      find(:class_match, "checkbox-old__CheckboxLabel", text: "Scheduled Ordering")
      find(:class_match, "expandable-option-box__HeaderButton", text: "Options")
      find(:class_match, SECTION_CONTAINER, text: "Pickup Minimum")
      find(:class_match, SECTION_CONTAINER, text: "Payment Types")
      find(:class_match, SECTION_CONTAINER, text: "After Hours Ordering")
    end

    def has_pickup_type_links?
      find(:class_match, "MuiTab-root", text: "In-Store Pickup")
      find(:class_match, "MuiTab-root", text: "Curbside Pickup")
      find(:class_match, "MuiTab-root", text: "Drive-Thru Pickup")
      find(:class_match, "MuiTab-root", text: "Delivery")
      find(:class_match, "MuiTab-root", text: "Kiosk")
    end
  end
end
