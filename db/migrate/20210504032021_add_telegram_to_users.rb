class AddTelegramToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :telegram, :string
  end
end
