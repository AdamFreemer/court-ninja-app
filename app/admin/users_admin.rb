Trestle.resource(:users) do
  before_action do
    unless current_user.admin?
      flash[:error] = I18n.t('admin.flash.unauthorized')
      redirect_to main_app.root_url
    end
  end

  menu do
    item :users, icon: 'fa fa-users'
  end

  scope :all, -> { User.all }, default: true
  scope :admin, -> { User.where(admin: true) }

  table do
    column :first_name
    column :last_name
    column :email
    column :admin
    actions
  end

  form do
    text_field :email
    text_field :first_name
    text_field :last_name

    hidden_field :password, { value: 'password123' }
    hidden_field :password_confirmation, { value: 'password123' }
  end
end
