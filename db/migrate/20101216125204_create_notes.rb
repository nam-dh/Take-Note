class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :title
      t.datetime :date
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
