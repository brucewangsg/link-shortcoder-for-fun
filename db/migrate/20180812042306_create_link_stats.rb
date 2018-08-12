class CreateLinkStats < ActiveRecord::Migration[5.1]
  def change
    create_table :link_stats do |t|
      t.bigint :link_id
      t.text :details
      t.timestamps
    end
    add_index :link_stats, :link_id
  end
end
