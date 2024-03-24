class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: {to_table: :users}
      t.string :content
      t.string :title

      t.timestamps
    end
  end
end
