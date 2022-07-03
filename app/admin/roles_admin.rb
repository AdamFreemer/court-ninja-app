Trestle.resource(:roles) do
  menu do
    item :roles, icon: 'fa fa-star', priority: 2
  end

  collection do
    model.order(:name)
  end

  table do
    column :name
    column :show_on_signup_form, header: 'Show on Signup Form?'
    column :created_at, header: 'Created'
    actions
  end

  form dialog: true do
    text_field :name
    check_box :show_on_signup_form, label: 'Show on Signup Form?'
  end
end
