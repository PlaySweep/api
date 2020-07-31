json.id prize.id
json.owner_abbreviation prize.product.owner.try(:abbreviation) || "Global"
json.name prize.product.name
json.size prize.sku.size