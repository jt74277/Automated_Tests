# frozen_string_literal: true

require_relative "./consumer"
require_relative "./global_nav"

# Dispensary details and menu page in Consumer, both Marketplace and Embedded Menu
module Dispensary
  CATEGORIES = {flower: "Flower", edibles: "Edibles"}.freeze
  MENU_STRINGS = {medical: "Med", recreational: "Rec"}.freeze
  private_constant :CATEGORIES
  private_constant :MENU_STRINGS

  # Dispensary info box below header ribbon - only appears on marketplace, not embedded
  class Header < SitePrism::Section
    set_default_search_arguments :data_cy, "dispensary-header"

    element :mobile_logo, :class_match, "dispensary-header-mobile__StyledImgix"
    element :hero_image, :class_match, "dispensary-header-details__Logo-"
    element :more_info_link, :data_test_id, "infoLink"
    element :menu_dropdown, :data_test_id, "select"

    # Pickup view
    element :pickup_estimate, :data_test_id, "pickupEstimate"
    element :pickup_minimum, :data_test_id, "minimumFee"
    element :pickup_status, :data_test_id, "openClose"
    element :delivery_toggle, :data_test_id, "deliveryToggle"

    # Delivery view
    element :delivery_estimate, :data_test_id, "deliveryEstimate"
    element :delivery_fee, :data_test_id, "deliveryFee"
    element :delivery_minimum, :data_test_id, "minimumOrder"
    element :delivery_status, :data_test_id, "deliveryStatus"
    element :pickup_toggle, :data_test_id, "pickupToggle"

    # Headers for desktop / mobile, when adding a header section to desktop/mobile main class it causes a conflict here.
    element :mobile_header, :class_match, "dispensary-header-mobile"
    element :desktop_header, :class_match, "dispensary-header-desktop__Container"

    # Matchers
    def has_medical_selected?
      has_menu_selected?(MENU_STRINGS[:medical])
    end

    def has_recreational_selected?
      has_menu_selected?(MENU_STRINGS[:recreational])
    end

    def has_delivery_selected?
      delivery_toggle["selected"] == "true"
    end

    def has_pickup_selected?
      pickup_toggle["selected"] == "true"
    end

    private

    def has_menu_selected?(menu)
      menu_dropdown.has_text? menu
    end
  end

  # Category list - only appears when clicking "Categories" in mobile nav
  class MobileCategories < SitePrism::Section
    set_default_search_arguments :class_match, "categories-list__Container"

    element :category, :class_match, "category-link__Anchor"
  end

  # Modal that prompts users to enter their delivery address
  class AddressModal < SitePrism::Section
    set_default_search_arguments :data_cy, "modal-container", text: "Enter a Delivery Address"

    element :address_field, :input, "streetAddress"
    element :apt_or_suite, :input, "apt"
    elements :address_suggestions, :data_test_id, "addressAutocompleteOption"
    element :save_button, :class_match, "delivery-address-form__StyledButton"

    # Actions
    # Default to Dutchie office in Bend
    def save_address(address="2777 NW Lolo Dr. suite 110", _apt=nil)
      address_field.click
      address_field.fill_in with: address
      address_suggestions.first.click
      save_button.click
    end
  end

  class CartItems < SitePrism::Section
    set_default_search_arguments :data_test_id, "cart-item-container"

    element :name, :class_match, "item__Name"
  end

  # Modal that pops up when an item is added to cart
  class AddToCartModal < SitePrism::Section
    set_default_search_arguments :class_match, "cart-dropdownstyles__Container"

    element :checkout_button, :data_test_id, "cart-checkout-button"
    element :keep_shopping, :data_test_id, "cart-close-button"

    sections :cart_items, CartItems
  end

  class OrderTypeModal < SitePrism::Section
    set_default_search_arguments :data_cy, "modal-container"

    element :pickup, :class_match, "OrderTypeButtonContainer", text: "Pickup"
    element :delivery, :class_match, "OrderTypeButtonContainer", text: "Delivery"
  end

  class ClosedButModal < SitePrism::Section
    set_default_search_arguments :data_test, "closed-but-modal"

    element :title, :class_match, "closed-but-modal__DispensaryClosedText"
    element :info, :class_match, "closed-but-info"
    element :continue_button, :class_match, "closed-but-modal__StyledButton", text: "CONTINUE"
    element :no_thanks_button, :class_match, "closed-but-modal__StyledTextButton", text: "No thanks"
  end

  # Home tab
  class Home < SitePrism::Section
    set_default_search_arguments :class_match, "main-content__Main"

    element :category_tile, :class_match, "categories-carousel-slider__TileWrapper"
  end

  # Product list pages
  class Products < SitePrism::Section
    set_default_search_arguments :class_match, "column__Container"
    load_validation { has_listed_product?(match: :first) }

    section :listed_product, :class_match, "product-list-item__Container" do
      element :image, :class_match, "product-image__LazyLoad"
      element :add_button, :class_match, "weight-tile__SingleTile"
      element :image_title, :class_match, "product-list-item__ProductName-"
      element :product_details, :class_match, "product-list-item__ProductDetails-"
    end

    element :sativa_strain, :id, "sativa", visible: :hidden

    # Actions
    def add_top_product_to_cart
      listed_product(match: :first).add_button.click
    end
  end

  # Product details page accessed by clicking on a product
  class ProductDetails < SitePrism::Section
    set_default_search_arguments :class_match, "layout__RootContainer"

    element :terpene_name, :class_match, "terpene__Name"
    element :first_terpene, :class_match, "terpene__Button"
    element :terpene_chart, :class_match, "terpene-pie-chart__LabelWrap"
    element :terpene_modal_desc, :class_match, "terpene-info__InfoDesc"

    element :cannabinoid_name, :class_match, "cannabinoid-grid-item__Identifier"
    element :cannabinoid_amount, :class_match, "cannabinoid-grid-item__Amount"
    element :first_cannabinoid, :class_match, "cannabinoid-grid-item", match: :first
    element :cannabinoid_description, :class_match, "cannabinoid-modal__Description"

    elements :weight_tiles, :class_match, "options-list__Button-"
    element :quantity_dropdown, :class_match, "quantity-select__StyledSelect"
    element :add_to_cart_button, :class_match, "StyledAddToCartButton"
    element :image, :class_match, "product-image__LazyLoad"
    element :keep_shopping, :class_match, "KeepShoppingButton"

    element :back, :class_match, "back-to-menu__Back-"

    def has_only_first_tile_bordered?
      weight_tiles.first.matches_style?(border: "2px solid rgb(11, 153, 230)")
      (1..2).all? do |n|
        weight_tiles[n].matches_style?(border: "2px solid rgb(11, 153, 230)", wait: 1) == false
      end
    end
  end

  class SearchResults < SitePrism::Section
    set_default_search_arguments :class_match, "column__Container"

    element :result_label, :class_match, "content-header__SearchResultsContainer"
  end

  class Page < BasePage
    attr_reader :menu_string

    extend Consumer
    # Custom load method to handle desktop/embedded and parsing dispensary if not on homepage
    def load(dispensary: nil, **options, &block)
      options.merge!({type: path_string, dispensary: dispensary.profile.cName}) if dispensary
      super(options, &block)
    end

    section :cart_pane, ConsumerGlobalNav::CartPane
    section :header, Header
    section :address_modal, AddressModal
    section :home, Home
    section :products, Products
    section :product_details, ProductDetails
    section :search_results, SearchResults

    section :mobile_categories, MobileCategories
    section :order_type_modal, OrderTypeModal
    section :closed_but_modal, ClosedButModal

    # Modal that confirms the user is at a residence and not a hotel, etc.
    section :residence_modal, :class_match, "residential-verification-modal__StyledModalContent" do
      element :yes_residence, :class_match, "residential-verification-modal__StyledButton", text: "YES"
    end

    # hover dropdown in the nav bar - options appear outside of sections. Desktop only
    element :hover_menu_item, :class_match, "hover-menu__HoverMenuItem"
    # Menu type options for selecting medical or recreational menu
    element :menu_type_option, :class_match, "select__Option-"
    # Mobile Only, this appears outside the navbar
    element :brands_link, :class_match, "MuiTab-wrapper", text: "Brands"
    # Brand sort by off the DOM
    element :brand_sort, :class_match, "MuiSelect-selectMenu"
    element :sort_selection, :class_match, "MuiMenuItem-gutters"
    # sort by box off dom
    element :sort_by_box, :class_match, "MuiSelect-select"
    element :brand_filter_select, :class_match, "MuiListItem-root"
    element :apply_filters_button, :class_match, "button__StyledButton", text: "APPLY FILTERS"

    # Should be part of product details, but its a script and not part of the product details section
    elements :drop_down_options, :class_match, "MuiMenuItem-root"
    element :drop_down_button, :class_match, "MuiListItem-button"
    element :drop_down_selection, :class_match, "MuiSelect-select"
    element :my_account_button, :class_match, "my-account-link__Account"
    # The List/Card display dropdown
    element :display_dropdown, :class_match, "menu-layout-selector__StyledSelect"
    element :display_option, :class_match, "menu-layout-selector__Label"
    element :product_card, :class_match, "product-cardcomponents__Content"

    # Actions

    def select_medical_menu
      select_menu(menu: MENU_STRINGS[:medical])
    end

    def select_recreational_menu
      select_menu(menu: MENU_STRINGS[:recreational])
    end

    def sort_brand_results(existing_sort:, sort_by:)
      # When I sort by price high to low
      brand_sort(text: existing_sort).click if desktop?
      wait_for_render
      # Then filters the brands by a criteria
      filter_selection(text: sort_by)
    end

    def add_item_to_cart(category, product)
      nav_bar.select_category(category)
      products.listed_product(text: product).image.click
      product_details.add_to_cart_button.click
    end

    private

    def select_menu(menu:)
      with_retry do
        header.menu_dropdown.click
        menu_type_option(text: menu, wait: 1).click
        header.menu_dropdown(text: menu, wait: 1)
      end
    end
  end

  module DesktopMain
    class NavBar < SitePrism::Section
      set_default_search_arguments :class_match, "dispensary-subheader-desktop__StickySubheader"

      element :nav_link, :class_match, "nav-links__MainAnchor"
      element :categories_dropdown, :class_match, "categories-dropdown__ButtonContainer"
      element :search_label, :class_match, "search__SearchLabel"
      element :search_field, :class_match, "search-input__InputField"
      element :sticky_subheader, :class_match, "dispensary-subheader-desktop__DispensaryName"
      element :subheader, :class_match, "dispensary-subheader-desktop__Container"
      element :home_link, :class_match, "nav-links__MainAnchor", text: "Home"

      # Actions
      def select_category(category)
        with_retry do
          categories_dropdown.hover
          parent_page.hover_menu_item(text: CATEGORIES[category]).click
        end
      end

      # Matchers
      def has_nav_item_selected?(label)
        element = label == "Categories" ? categories_dropdown : nav_link(text: label)
        element.matches_style?("border-bottom": "2px solid rgb(38, 162, 123)")
      end

      def has_no_header?
        has_selector?(:class_match, "dispensary-subheader-desktop__DispensaryName")
      end
    end

    class Page < Dispensary::Page
      def path_string
        "dispensary"
      end

      set_url "#{base_url}{/type}{/dispensary}{/area}{/sub_area}"

      section :top_bar, ConsumerGlobalNav::DesktopTopBar
      section :nav_bar, DesktopMain::NavBar
      section :add_to_cart_modal, AddToCartModal, :data_test_id, "cart-dropdown"

      # Actions
      def click_home
        nav_bar.home_link.click
      end
    end
  end

  module MobileMain
    class NavBar < SitePrism::Section
      set_default_search_arguments :class_match, "dispensary-subheader-mobile__StickySubheader"

      element :nav_link, :class_match, "dispensary-subheader-mobile__StyledTab-"
      element :search_label, :class_match, "dispensary-subheader-mobile__FakeTab"
      element :search_field, :class_match, "search-input__StyledFormControl"
      element :active_element_underline, :class_match, "MuiTabs-indicator"
      element :header, :class_match, "dispensary-header"
      element :subheader, :class_match, "dispensary-subheader-mobile"

      # Actions
      def select_category(category)
        nav_link(text: "Categories").click
        with_retry do
          parent.mobile_categories.category(text: CATEGORIES[category]).click
          parent.products.listed_product(match: :first, wait: 3)
        end
      end

      # Matchers
      def has_nav_item_selected?(label)
        # underline isn't connected to the button, so we have to check that it is present and that the
        # button registers as selected instead of checking for it to be attached.
        nav_link(text: label)["aria-selected"] == "true" && has_active_element_underline?
      end
    end

    class Page < Dispensary::Page
      def path_string
        "dispensary"
      end

      set_url "#{base_url}{/type}{/dispensary}{/area}{/sub_area}"

      section :top_bar, ConsumerGlobalNav::MobileTopBar
      section :nav_bar, MobileMain::NavBar
      section :add_to_cart_modal, AddToCartModal, :data_test_id, "cart-dropdown"

      # Actions
      def click_home
        top_bar.home_link.click
      end
    end
  end

  module Kiosk
    class NavBar < SitePrism::Section
      set_default_search_arguments :class_match, "subheader__Container"

      element :categories_dropdown, :class_match, "categories-dropdown__ButtonContainer"

      # Actions
      def select_category(category)
        categories_dropdown.hover
        parent_page.hover_menu_item(text: category).click
      end
    end

    class KioskCheckoutModal < SitePrism::Section
      set_default_search_arguments :class_match, "kiosk-checkout__Container"

      element :anonymous_checkout,  :id,          "anonymous-kiosk-checkout", visible: :hidden
      element :order_info_field,    :class_match, "components__InputContainer"
      element :submit_order_button, :class_match, "button__ButtonContainer", text: "SUBMIT ORDER"

      # Matchers
      def has_no_input_field?
        has_no_selector?(:class_match, "components__InputContainer")
      end
    end

    class KioskOrderSubmittedModal < SitePrism::Section
      set_default_search_arguments :data_cy, "modal-container"

      element :order_number, :class_match, "success__StyledText"
    end

    class Page < Dispensary::Page
      def path_string
        "kiosks"
      end

      set_url "#{base_url}{/type}{/dispensary}{/area}{/sub_area}"

      section :top_bar, ConsumerGlobalNav::DesktopTopBar
      section :nav_bar, Kiosk::NavBar
      section :add_to_cart_modal, AddToCartModal, :data_test_id, "cart-dropdown"
      section :kiosk_checkout_modal, KioskCheckoutModal
      section :kiosk_order_submitted_modal, KioskOrderSubmittedModal
    end
  end

  module DesktopEmbedded
    class Nav < SitePrism::Section
      set_default_search_arguments :class_match, "core-menu-header__Container", match: :first

      element :categories_dropdown, :class_match, "categories-dropdown__ButtonContainer"
      element :cart_icon, :data_test_id, "cartButton"
      element :cart_item_count, :class_match, "button__ItemCount"
      element :brands_link, :class_match, "nav-links__EmbeddedAnchor", text: "Brands"

      # Actions
      def click_brands
        brands_link.click
      end

      def select_category(category)
        categories_dropdown.hover
        parent_page.hover_menu_item(text: CATEGORIES[category]).click
      end

      # Matchers
      def has_cart_count?(count)
        cart_item_count.text.to_i == count
      end

      def has_empty_cart?
        has_cart_count?(0)
      end
    end

    class Page < Dispensary::Page
      def path_string
        "embedded-menu"
      end

      set_url "#{base_url}{/type}{/dispensary}{/area}{/sub_area}"

      def filter_selection(text)
        sort_selection(text: text.values[0]).click
      end
      section :login_modal, SharedModals::LoginModal
      section :create_account_modal, SharedModals::CreateAccountModal
      section :top_bar, ConsumerGlobalNav::DesktopEmbeddedTop
      section :nav_bar, ConsumerGlobalNav::DesktopEmbeddedTop
      section :add_to_cart_modal, AddToCartModal, :data_test_id, "cart-dropdown"

      element :my_account_dropdown, :class_match, "my-account-options-list__Anchor"
      element :logout_link, :class_match, "my-account-options-list", text: "Logout"
      element :logged_out_my_account_options, :class_match, "my-account-options-list"

      element :brand_name, :class_match, "section__Container"
      element :menu_layout, :class_match, "menu-layout-selector__StyledSelect"
      element :first_item, :class_match, "desktop-product-list-item__ProductName", match: :first
    end
  end

  module MobileEmbedded
    class Nav < SitePrism::Section
      set_default_search_arguments :class_match, "core-menu-header__Container", match: :first

      element :menu_button, :class_match, "MobileMenuContainer"
      element :cart_icon, :data_test_id, "cartButton"
      element :cart_item_count, :class_match, "button__ItemCount"

      # Actions
      def select_category(category)
        menu_button.click
        with_retry do
          parent.mobile_categories.category(text: CATEGORIES[category]).click
          parent.products.listed_product(match: :first, wait: 3)
        end
      end

      def click_brands
        menu_button.click
        wait_for_render
        parent.brands_link.click
      end

      # Matchers
      def has_cart_count?(count)
        cart_item_count.text.to_i == count
      end

      def has_empty_cart?
        has_cart_count?(0)
      end
    end

    class Page < Dispensary::Page
      def path_string
        "embedded-menu"
      end

      set_url "#{base_url}{/type}{/dispensary}{/area}{/sub_area}"

      section :login_modal, SharedModals::LoginModal
      section :create_account_modal, SharedModals::CreateAccountModal

      element :brand_filter, :class_match, "drawer-toggle-button__Text"
      element :brand_name, "section__Container"
      element :first_item, :class_match, "mobile-product-list-item__ProductName", match: :first
      element :my_account_dropdown, :class_match, "my-account-options-list__Anchor", text: "{/selection}"
      element :logged_out_my_account_options, :class_match, "my-account-options-list", text: "{/selection}"
      element :logout_link, :class_match, "my-account-options-list", text: "Logout"

      def filter_selection(text)
        brand_filter.click
        wait_for_render
        sort_by_box.click
        wait_for_render
        brand_filter_select(text: text.values[0]).click
        wait_for_render
        apply_filters_button.click
        wait_for_render
      end

      section :top_bar, ConsumerGlobalNav::MobileEmbeddedTop
      section :nav_bar, ConsumerGlobalNav::MobileEmbeddedTop
      section :add_to_cart_modal, AddToCartModal, :data_test_id, "cart-dropdown"
    end
  end
end

