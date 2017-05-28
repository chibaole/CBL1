require "administrate/base_dashboard"

class PromotionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    products: Field::HasMany,
    code_batches: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    started_at: Field::DateTime,
    state: Field::String.with_options(searchable: false),
    expired_at: Field::DateTime,
    message_template: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :products,
    :code_batches,
    :id,
    :name,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :products,
    :code_batches,
    :id,
    :name,
    :started_at,
    :state,
    :expired_at,
    :message_template,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :products,
    :code_batches,
    :name,
    :started_at,
    :state,
    :expired_at,
    :message_template,
  ].freeze

  # Overwrite this method to customize how promotions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(promotion)
  #   "Promotion ##{promotion.id}"
  # end
end
