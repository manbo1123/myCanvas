class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :problem
      t.text :existing
      t.text :solution
      t.text :metics
      t.text :value
      t.text :advantage
      t.text :channel
      t.text :customer
      t.text :cost
      t.text :revenue

      t.timestamps
    end
  end
end
