class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :facebook_code

      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end
