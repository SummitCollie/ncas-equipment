class AddWebsocketColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :websocket_id, :string
    add_column :users, :websocket_action, :string
  end
end
