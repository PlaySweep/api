json.id prize.id
json.prizeable_id prize.prizeable_id
json.prizeable_type prize.prizeable_type
json.prizeable prize.prizeable
json.product prize.product, partial: 'v2/admin/products/product', as: :product
json.sku do
  json.id prize.sku_id
  json.size prize.sku.size
end
json.name prize.product.name
json.category prize.product.category
json.global prize.product.global
json.orders prize.orders, partial: 'v2/orders/order', as: :order