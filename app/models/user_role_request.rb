# == Schema Information
#
# Table name: user_role_requests
#
#  id              :bigint           not null, primary key
#  processed_at    :datetime
#  status          :string           default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  processed_by_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_user_role_requests_on_processed_by_id  (processed_by_id)
#  index_user_role_requests_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (processed_by_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class UserRoleRequest < ApplicationRecord
  rolify

  belongs_to :user
  belongs_to :processed_by, class_name: 'User', optional: true

  def send_user_request_email
    UserMailer.user_request_email(self).deliver_now
  end
end
