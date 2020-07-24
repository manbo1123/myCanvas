class AddUserToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :user, fpreign_key: true
  end
end
