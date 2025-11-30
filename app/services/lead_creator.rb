# app/services/lead_creator.rb
class LeadCreator
  def self.create_lead(attributes)
    lead = Lead.new(attributes)
    lead.save
    lead
  end

  def self.create_lead!(attributes)
    lead = Lead.new(attributes)
    lead.save!
    lead
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create lead: #{e.message}"
    raise e
  end
end