# == Schema Information
#
# Table name: roles
#
#  id                  :bigint           not null, primary key
#  name                :string
#  resource_type       :string
#  show_on_signup_form :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_id         :bigint
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
class Role < ApplicationRecord
  has_many :users_roles, dependent: :destroy
  has_many :users, through: :users_roles

  has_many :users_role_requests_roles, dependent: :destroy
  has_many :user_role_requests, through: :users_role_requests_roles

  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify
end
