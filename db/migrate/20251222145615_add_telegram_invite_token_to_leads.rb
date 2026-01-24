class AddTelegramInviteTokenToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :invite_token, :string
  end
end
