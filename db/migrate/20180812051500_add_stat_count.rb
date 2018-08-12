class AddStatCount < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :visit_count, :bigint, default: 0
  end
end
