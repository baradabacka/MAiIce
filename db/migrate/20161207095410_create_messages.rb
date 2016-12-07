class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :employee
      t.string :url
      t.string :email
      t.text :commit

      t.timestamps
    end
  end
end
