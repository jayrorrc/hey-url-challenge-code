# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks

  validates :original_url, :short_url, :clicks_count, presence: true
  validates :original_url, :short_url, uniqueness: true
  validates_format_of :original_url, { with: URI.regexp, message: "This is not a valid url"}
  validates_length_of :short_url, maximum: 5
  validates :short_url, format: { with: /\A[a-zA-Z0-9]+\z/ }

  def clicks_count
    clicks.where("created_at >= ? AND created_at <= ?", Time.now.beginning_of_month, Time.now.end_of_month).length
  end
end
