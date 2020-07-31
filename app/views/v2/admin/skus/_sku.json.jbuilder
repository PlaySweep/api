json.id sku.id
json.owner_abbreviation sku.product.owner.try(:abbreviation) || "Global"
json.product_id sku.product_id
json.name sku.product.name
json.owner_id sku.product.owner_id
json.size sku.size