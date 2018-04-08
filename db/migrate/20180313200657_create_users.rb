class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.bigint :id_code
      t.string :email
      t.string :id_type

      t.timestamps
    end
  end
end
