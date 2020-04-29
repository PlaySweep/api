json.id product.id
json.name product.name
json.description product.description
json.skus product.skus.each do |sku|
  json.id sku.id
end
json.team_id product.owner_id