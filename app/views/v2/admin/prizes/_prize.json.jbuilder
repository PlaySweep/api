json.id prize.id
json.owner_abbreviation prize.product.owner.try(:abbreviation) || "Global"
json.owner_id prize.product.owner_id
json.prizeable_id prize.prizeable_id
json.prizeable_type prize.prizeable_type
json.name prize.product.name
json.size prize.sku.size