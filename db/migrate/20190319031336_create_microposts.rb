class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts, comment: "投稿" do |t|
      t.text :content, comment: "内容"
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
