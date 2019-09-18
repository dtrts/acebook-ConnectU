class AddingUsername < ActiveRecord::Migration[5.1]
  #def change
  #  add_column(:users, :username, :string, default: :id)
  #  add_index(:users, :username, uniqueness: true)
  #end

  def up
    execute("
      alter table users add column username varchar(255);
      update users set username = concat('User',id); 
      alter table users alter column username set not null; 
      create unique index unique_user_name on users (username);
      ")
  end

  def down
    execute("
      alter table users drop column username
      ")
  end
end
