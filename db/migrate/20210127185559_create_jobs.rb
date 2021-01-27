class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :position
      t.string :company
      t.string :location
      t.string :salary
      t.string :date
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
