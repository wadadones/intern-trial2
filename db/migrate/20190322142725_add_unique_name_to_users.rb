class AddUniqueNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unique_name, :string, comment: "一意なユーザー名"
  end
end
