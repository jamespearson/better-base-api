class AddRolesMaskToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :roles_mask, :integer
  end
end
