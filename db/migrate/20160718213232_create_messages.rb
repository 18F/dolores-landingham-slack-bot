class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.datetime :last_sent_at
      t.timestamps null: false
    end
  end
end
