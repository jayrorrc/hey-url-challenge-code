# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  validates :browser, :platform, presence: true
end
