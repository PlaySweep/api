json.id slate.id
json.name slate.name
json.description slate.description
json.status slate.status
json.start_time slate.start_time
json.prize do
  json.id slate.prize.id
  json.product do 
    json.id slate.prize.product.id
    json.name slate.prize.product.name
    json.category slate.prize.product.category
  end
  json.date slate.prize.date
end unless slate.contest_id?
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.sku_id prize.sku_id
  json.product_id prize.product_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.image prize.product.image
  json.category prize.product.category
  json.date prize.date
end