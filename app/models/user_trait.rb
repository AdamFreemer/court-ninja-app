# frozen_string_literal: true

class UserTrait < ApplicationRecord
  belongs_to :user
  belongs_to :trait
end
