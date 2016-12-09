class CreateMessages < ActiveRecord::Migration

  # def self.up
  #     add_column :messages, :aasm_state, :string
  #   end
  #
  # def self.down
  #     remove_column :messages, :aasm_state
  # end

  def change
    create_table :messages do |t|
      t.string :employee
      t.string :url
      t.string :email
      t.text :commit
      t.string :aasm_state

      t.timestamps
    end
  end
end
