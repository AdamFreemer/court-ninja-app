Trestle.resource(:user_role_requests) do
  menu do
    item :user_role_requests, icon: 'fa fa-question', priority: 2
  end

  scope :all, -> { UserRoleRequest.all }, default: true
  scope :pending, -> { UserRoleRequest.where(status: 'pending') }
  scope :approved, -> { UserRoleRequest.where(status: 'approved') }
  scope :denied, -> { UserRoleRequest.where(status: 'denied') }

  table do
    column :user
    column :role
    column :status
    column :processed_by, header: 'Processed By'
    column :processed_at, header: 'Processed At'
    column :approve do |r|
      link_to('Approve', main_app.approve_user_role_request_url(r.id)) if r.status == 'pending'
    end
    column :deny do |r|
      link_to('Deny', main_app.deny_user_role_request_url(r.id)) if r.status == 'pending'
    end
  end
end
