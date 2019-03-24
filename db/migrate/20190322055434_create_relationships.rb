class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships, comment: "ユーザーのフォロー関係" do |t|
      t.integer :follower_id, comment: "フォローしているユーザーID"
      t.integer :followed_id, comment: "フォローされているユーザーID"

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
