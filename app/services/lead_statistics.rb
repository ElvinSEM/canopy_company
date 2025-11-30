# app/services/lead_statistics.rb
class LeadStatistics
  def self.status_counts
    Lead.group(:status).count
  end

  def self.recent_leads(limit = 5)
    Lead.recent(limit)
  end

  def self.leads_today
    Lead.where(created_at: Time.current.all_day).count
  end

  def self.leads_by_week
    Lead.group_by_week(:created_at).count
  end
end