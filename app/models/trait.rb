# frozen_string_literal: true

# == Schema Information
#
# Table name: traits
#
#  id             :bigint           not null, primary key
#  description    :string
#  is_objective?  :boolean
#  is_subjective? :boolean
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Trait < ApplicationRecord
  has_many :user_traits
end
