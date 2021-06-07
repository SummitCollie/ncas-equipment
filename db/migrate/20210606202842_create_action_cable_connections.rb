class CreateActionCableConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :action_cable_connections do |t|
      t.string :connection_identifier, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :last_used, null: false

      t.timestamps
    end
  end
end
