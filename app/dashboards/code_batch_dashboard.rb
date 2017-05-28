require "administrate/base_dashboard"

class CodeBatchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    promotion: Field::BelongsTo,
    promotion_codes: Field::HasMany,
    id: Field::Number,
    note: Field::String,
    expired_at: Field::DateTime,
    count: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :promotion,
    :promotion_codes,
    :id,
    :note,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :promotion,
    :promotion_codes,
    :id,
    :note,
    :expired_at,
    :count,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :promotion,
    :promotion_codes,
    :note,
    :expired_at,
    :count,
  ].freeze

  # Overwrite this method to customize how code batches are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(code_batch)
  #   "CodeBatch ##{code_batch.id}"
  # end
end
