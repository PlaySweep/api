json.id prize.id
json.prizeable_id prize.prizeable_id
json.prizeable_type prize.prizeable_type
json.prizeable prize.prizeable
json.product_id prize.product_id
json.sku do
  json.id prize.sku_id
  json.size prize.sku.size
end
json.name prize.product.name
json.category prize.product.category
json.global prize.product.global
json.orders prize.orders, partial: 'v1/orders/order', as: :order