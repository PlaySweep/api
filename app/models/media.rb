class Media < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  
  after_create :set_attachment_id

  scope :by_category, ->(category) { where(category: category.split('_').join(' ')) } 

  private

  def set_attachment_id
    conn = Faraday.new(:url => "https://graph.facebook.com/v8.0/me/")
    params = {message: {attachment: {type: 'image', payload: { is_reusable: true, url: self.url}}}}
    response = conn.post("message_attachments?access_token=#{ENV['ACCESS_TOKEN']}", params)
    attachment_id = JSON.parse(response.body)["attachment_id"]
    self.update_attributes(attachment_id: attachment_id)
  end 
end