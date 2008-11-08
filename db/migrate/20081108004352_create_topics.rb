class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :forum_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
