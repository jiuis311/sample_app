class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.string :subject

      t.timestamps
    end
  end
end
