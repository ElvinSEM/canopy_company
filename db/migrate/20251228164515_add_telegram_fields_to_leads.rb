class AddTelegramFieldsToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :telegram_chat_id, :bigint
    add_column :leads, :telegram_username, :string
    add_column :leads, :subscribed_to_channel, :boolean
    add_column :leads, :subscription_confirmed_at, :datetime
  end
end
