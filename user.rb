class User
  before_validation :set_access_token
 
  def date_format
    super.presence || "%d.%m.%Y"
  end
 
  private
 
  def set_access_token
    self.access_token ||= SecureRandom.uuid
  end
end

require "rails_helper"

describe User do
  subject(:user) { described_class.new(name: "Name") }

  describe "before_validation" do
    before do
      user.valid?
    end

    it "set access token" do
      expect(user.access_token).not_to eq nil 
    end
  end

  describe "#date_format" do
    it "return valid date format" do
      expect(user.date_format).to change { user.reload.date_format }.from(nil).to("%d.%m.%Y") 
    end
  end
end
