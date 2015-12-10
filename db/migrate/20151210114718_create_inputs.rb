class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :file

      t.timestamps
    end
  end
end
