require 'rails_helper'

describe Discount do
  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:percentage) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:items).through(:merchant) }
  end
end