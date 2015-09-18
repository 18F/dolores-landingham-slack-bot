class CreateScheduledMessages < ActiveRecord::Migration
  def change
    create_table :scheduled_messages do |t|
      t.timestamps null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :days_after_start, null: false
    end
  end
end
