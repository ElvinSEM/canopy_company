# test/models/lead_test.rb
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  # Просто не указываем fixtures вообще

  test "class exists" do
    assert_kind_of Class, Lead
  end

  test "can create lead" do
    lead = Lead.new(
      name: "Тест",
      email: "test@example.com"
    )
    assert lead.valid?
  end
end