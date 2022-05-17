# frozen_string_literal: true

# == Schema Information
#
# Table name: user_traits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trait_id   :integer
#  user_id    :integer
#
class UserTrait < ApplicationRecord
  belongs_to :user
  belongs_to :trait
end
