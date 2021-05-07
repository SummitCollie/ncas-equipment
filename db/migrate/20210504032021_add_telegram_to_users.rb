class AddTelegramToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :telegram, :string
    add_column :users, :telegram_chat_id, :string
  end
end
