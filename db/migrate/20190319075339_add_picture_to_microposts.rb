class AddPictureToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :picture, :string, comment: "ユーザー画像"
  end
end
