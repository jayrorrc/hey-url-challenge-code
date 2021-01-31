# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it { should belong_to(:url) }
    it { should validate_presence_of(:browser) }
    it { should validate_presence_of(:platform) }
  end
end
