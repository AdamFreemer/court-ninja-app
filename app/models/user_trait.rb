# frozen_string_literal: true

# == Schema Information
#
# Table name: user_traits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trait_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_traits_on_trait_id  (trait_id)
#  index_user_traits_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (trait_id => traits.id)
#  fk_rails_...  (user_id => users.id)
#
class UserTrait < ApplicationRecord
  belongs_to :user
  belongs_to :trait
end
