class CreateSnsCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :sns_credentials do |t|
      t.string :provider
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end

    # usersテーブルの provider、uidは削除
    remove_columns :users, :provider, :uid
  end
end
