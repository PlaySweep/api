class CreateBackgroundJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :background_jobs do |t|
      t.string :job_name
      t.string :job_id
      t.string :resource
      t.integer :resource_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
