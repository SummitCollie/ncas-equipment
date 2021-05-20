class CreateSentTelegramMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :sent_telegram_messages do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :message_id, null: false
      t.string :purpose, null: false

      t.timestamps
    end
  end
end
