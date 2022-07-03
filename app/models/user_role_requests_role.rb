# == Schema Information
#
# Table name: user_role_requests_roles
#
#  role_id              :bigint
#  user_role_request_id :bigint
#
# Indexes
#
#  index_user_role_requests_roles_on_role_id                     (role_id)
#  index_user_role_requests_roles_on_user_role_request_and_role  (user_role_request_id,role_id)
#  index_user_role_requests_roles_on_user_role_request_id        (user_role_request_id)
#
class UserRoleRequestsRole < ApplicationRecord
  belongs_to :user_role_request
  belongs_to :role
end
