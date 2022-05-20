class AddAdminFlagToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, default: false

    User.all.each do |user|
      user.admin =
        if ['luckymak@gmail.com', 'afreemer@gmail.com', 'dmbrooking@gmail.com'].include?(user.email)
          true
        else
          false
        end

      user.save!
    end
  end
end
