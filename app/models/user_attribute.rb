# frozen_string_literal: true

class UserAttribute < ApplicationRecord
  belongs_to :user
  belongs_to :attribute
end
