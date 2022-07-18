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
  # Comment out 19-21 when rebuilding db
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
    row do
      col(sm: 6) { text_field :first_name, label: 'First Name' }
      col(sm: 6) { text_field :last_name, label: 'Last Name' }
    end

    text_field :phone_number, label: 'Phone Number'

    text_field :address
    row do
      col(sm: 6) { text_field :city }
      col(sm: 3) { text_field :state }
      col(sm: 3) { text_field :zip }
    end

    divider

    h5 'Player Info'
    row do
      col(sm: 6) { text_field :nick_name, label: 'Nickname' }
      col(sm: 6) { text_field :gender }
    end
    row do
      col(sm: 6) { text_field :position }
      col(sm: 6) { text_field :jersey_number, label: 'Jersey Number' }
    end

    divider

    h5 'Contact'
    row do
      col(sm: 6) { text_field :contact_1_name, label: 'Contact #1 Name' }
      col(sm: 6) { text_field :contact_2_name, label: 'Contact #2 Name' }
    end
    row do
      col(sm: 6) { text_field :contact_1_address, label: 'Contact #1 Address' }
      col(sm: 6) { text_field :contact_2_address, label: 'Contact #2 Address' }
    end
    row do
      col(sm: 6) { text_field :contact_1_phone, label: 'Contact #1 Phone' }
      col(sm: 6) { text_field :contact_2_phone, label: 'Contact #2 Phone' }
    end

    divider

    h5 'Admin'
    static_field :last_sign_in_at if u.last_sign_in_at?

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
