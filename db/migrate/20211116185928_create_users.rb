class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.integer :login_failure_count
      t.datetime :locked_at

      t.timestamps
    end
  end
end
