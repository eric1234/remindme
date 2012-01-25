class AddPasswordReset < ActiveRecord::Migration

  def change
    table_name = Remindme.authenticated_model_name.downcase.pluralize.to_sym
    add_column table_name, :perishable_token, :string if table_exists? table_name
  end

end