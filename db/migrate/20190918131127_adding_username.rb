class AddingUsername < ActiveRecord::Migration[5.1]
  def change
    add_column(:users, :username , :string, default: "#{:id}")
    add_index(:users, :username)
  end
end
