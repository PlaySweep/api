json.id prize.id
json.owner_abbreviation prize.product.owner.try(:abbreviation) || "Global"
json.owner_id prize.product.owner_id
json.name prize.product.name
json.size prize.sku.size