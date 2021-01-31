# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { described_class.new(
    short_url: "123",
    original_url: "http://google.com",
    clicks_count: 0
  )}

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end


  describe 'validations' do
    it { should have_many(:clicks) }
    it { should validate_presence_of(:short_url) }
    it { should validate_presence_of(:original_url) }

    describe 'original url' do
      it 'validates original URL is a valid URL' do
        should allow_values('http://foo.com', 'https://bar.com')
          .for(:original_url)

        should_not allow_values('foo', 'buz')
          .for(:original_url)
          .with_message('This is not a valid url')

      end

      it { should validate_uniqueness_of(:original_url) }
    end

    describe 'short url' do
      it 'max length 5 character e.g. NELNT' do
        should validate_length_of(:short_url)
          .is_at_most(5)
      end

      it 'allows uppercase and lowercase characters' do
        should allow_values(Array.new(5) {Array('A'..'Z').sample}.join)
          .for(:short_url)

        should allow_values(Array.new(5) {Array('a'..'z').sample}.join)
          .for(:short_url)
      end

      it 'allows number' do
        should allow_values(Array.new(5) {Array(0..9).sample}.join)
          .for(:short_url)
      end

      it 'any non-word character is not allowed e.g whitespaces, tab,% ,$.* etc' do
        should_not allow_values(' ', '*', '@', '#', '$', '.')
          .for(:short_url)
      end

      it { should validate_uniqueness_of(:short_url).ignoring_case_sensitivity }
    end
  end
end
