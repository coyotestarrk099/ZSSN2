class CreateReportLists < ActiveRecord::Migration[5.2]
  def change
    create_table :report_lists do |t|
      t.integer :reportedId
      t.integer :reporterId

      t.timestamps
    end
  end
end
