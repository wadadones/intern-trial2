class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, comment: "ユーザー" do |t|
      t.string :name, comment: "ユーザー名"
      t.string :email, comment: "ユーザーのメールアドレス"

      t.timestamps
    end
  end
end
