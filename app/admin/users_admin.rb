Trestle.resource(:users) do
  menu do
    item :users, icon: 'fa fa-users', priority: 1
  end

  before_action do
    unless current_user.has_role?(:admin)
      flash[:error] = I18n.t('admin.flash.unauthorized')
      redirect_to main_app.root_url
    end
  end

  collection do
    model.where(is_ghost_player: false)
  end

  scope :all, -> { User.all }, default: true
  Role.all.each do |role|
    scope role.name.downcase.to_sym, -> { User.with_role(role.name) }
  end

  table do
    column :first_name
    column :last_name
    column :email
    column :admin do |u|
      u.has_role?(:admin)
    end
    actions
  end

  form do |u|
    text_field :email
    text_field :first_name
    text_field :last_name

    if u.new_record?
      hidden_field :password, { value: 'password123' }
      hidden_field :password_confirmation, { value: 'password123' }
    end
  end

  # Ignore the password parameters if they are blank
  update_instance do |instance, attrs|
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation) if attrs[:password_confirmation].blank?
    end
    instance.assign_attributes(attrs)
  end
end
