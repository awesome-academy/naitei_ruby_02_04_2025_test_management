# frozen_string_literal: true

# Tên file: YYYYMMDDHHMMSS_add_devise_to_users.rb (đây là file Devise đã tạo)
class AddDeviseToUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :password_digest, :string, if_exists: true
    remove_column :users, :remember_digest, :string, if_exists: true
    remove_column :users, :activation_digest, :string, if_exists: true
    remove_column :users, :activated, :boolean, if_exists: true
    remove_column :users, :activated_at, :datetime, if_exists: true
    remove_column :users, :reset_digest, :string, if_exists: true
    remove_column :users, :reset_sent_at, :datetime, if_exists: true

    change_table :users do |t|
      unless column_exists?(:users, :email)
        t.string :email,              null: false, default: ""
      else
        change_column_default :users, :email, from: nil, to: ""
        change_column_null :users, :email, false
      end

      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      unless column_exists?(:users, :reset_password_token)
        t.string   :reset_password_token
      end
      unless column_exists?(:users, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end

      unless column_exists?(:users, :remember_created_at)
        t.datetime :remember_created_at
      end

      unless column_exists?(:users, :confirmation_token)
        t.string   :confirmation_token
      end
      unless column_exists?(:users, :confirmed_at)
        t.datetime :confirmed_at
      end
      unless column_exists?(:users, :confirmation_sent_at)
        t.datetime :confirmation_sent_at
      end
      unless column_exists?(:users, :unconfirmed_email)
        t.string   :unconfirmed_email
      end
    end
    
    add_index :users, :email,                unique: true, if_not_exists: true
    add_index :users, :reset_password_token, unique: true, if_not_exists: true
    add_index :users, :confirmation_token,   unique: true, if_not_exists: true
  end

  def down
    remove_columns :users,
                   :encrypted_password,
                   :reset_password_token,
                   :reset_password_sent_at,
                   :remember_created_at,
                   :confirmation_token,
                   :confirmed_at,
                   :confirmation_sent_at,
                   :unconfirmed_email
    remove_index :users, :reset_password_token, if_exists: true
    remove_index :users, :confirmation_token, if_exists: true

    add_column :users, :password_digest, :string, null: false unless column_exists?(:users, :password_digest)
    add_column :users, :remember_digest, :string unless column_exists?(:users, :remember_digest)
    add_column :users, :activation_digest, :string unless column_exists?(:users, :activation_digest)
    add_column :users, :activated, :boolean, null: false, default: false unless column_exists?(:users, :activated)
    add_column :users, :activated_at, :datetime unless column_exists?(:users, :activated_at)
    add_column :users, :reset_digest, :string unless column_exists?(:users, :reset_digest)
    add_column :users, :reset_sent_at, :datetime unless column_exists?(:users, :reset_sent_at)
  end
end
