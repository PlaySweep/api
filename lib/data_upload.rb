class DataUpload
  def initialize
    @path = "#{Rails.root}/tmp"
  end

  def write_products
    Apartment::Tenant.switch!('budweiser')
    CSV.open("#{@path}/products.csv", 'wb') do |csv|
      csv << ["id", "name", "team", "category"]
      Product.active.each do |product|
        csv << [product.id, product.name, product.team.name, product.category]
      end
    end
  end

  def upload_slates
    Apartment::Tenant.switch!('budweiser')
    slates_data = CSV.read("#{@path}/slates.csv")[1..-1]
    slates_data.each_with_index do |row, index|
      team = Team.find_by(name: row[4])
      opponent = Team.find_by(name: row[7])
      date_attributes = row[2].split("/")
      month, day, year, hour, minute = date_attributes[0].to_i, date_attributes[1].to_i, date_attributes[2].split(' ')[0].to_i, date_attributes[2].split(' ').split(':').flatten[1].split(":")[0].to_i, date_attributes[2].split(' ').split(':').flatten[1].split(":")[1].to_i
      date = DateTime.new(year, month, day, hour, minute, 0)
      data = {
        name: row[1],
        start_time: date,
        type: row[3],
        owner_id: team.try(:id),
        local: row[5],
        field: row[6],
        opponent_id: opponent.try(:id)
      }
      
      slate = Slate.new(data)
      product = Product.find_by(id: row[8])
      if product
        row[9] ? slate.prizes.build(product_id: product.id, sku_id: product.skus.first.id, date: row[9]) : slate.prizes.build(product_id: product.id, sku_id: product.skus.first.id)
      end
      assign_events_to(slate: slate, temporary_slate_id: row[0])
    end
  end

  def assign_events_to slate:, temporary_slate_id:
    Apartment::Tenant.switch!('budweiser')
    events_data = CSV.read("#{@path}/events.csv")[1..-1]

    events_data.each_with_index do |row, index|
      if temporary_slate_id == row[2]
        data = {
          description: row[1],
          type: row[3],
          order: row[4],
          category: row[5]
        }
        event = slate.events.build(data)
        slate.save
        assign_selections_to(event: event, temporary_event_id: row[0])
      end
    end
  end

  def assign_selections_to event:, temporary_event_id:
    selections_data = CSV.read("#{@path}/selections.csv")[1..-1]
    selections_data.each_with_index do |row, index|
      if row[2] == temporary_event_id
        data = {
          description: row[1],
          order: row[3]
        }
        selection = event.selections.build(data)
        event.save
      end
    end
  end
end