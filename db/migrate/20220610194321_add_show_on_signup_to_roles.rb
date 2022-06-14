class AddShowOnSignupToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :show_on_signup_form, :boolean, default: false
  end
end
