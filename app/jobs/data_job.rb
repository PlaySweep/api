class DataJob < ApplicationJob
  @queue = :data_job

  def perform
    DataMigration.create_and_update_location(tenant: tenant)
  end
end