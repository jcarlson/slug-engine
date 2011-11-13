class CreatePermalinks < ActiveRecord::Migration
  def change
    create_table :permalinks do |t|
      t.string :slug
      t.integer :content_id
      t.string :content_type

      t.timestamps
    end
  end
end
