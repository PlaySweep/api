require 'yaml'
require 'json'

def credentials
  json_data = YAML::load_file("#{Rails.root}/config/application.yml").to_json
  JSON.parse(json_data, object_class: OpenStruct)
end