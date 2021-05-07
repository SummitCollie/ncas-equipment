class CreateMagicTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :magic_tokens do |t|
      t.string :token, null: false
      t.datetime :expires, null: false
      t.string :purpose, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
