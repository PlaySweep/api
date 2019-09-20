module Indicative
  class TrackEvent
    @api = ENV["INDICATIVE_API_BASE_URL"]

    def self.new_user user:
      body = {
          apiKey: ENV["INDICATIVE_API_KEY"],
          eventName: "New user",
          eventUniqueId: user.id,
          properties: {
              ref: user.referral,
          }
      }.to_json

      response = HTTParty.post(
        "#{@api}/event",
        :headers => { "Content-Type" => "application/json" },
        :body => body
      )
    end

    def self.confirmed_account user:
      body = {
          apiKey: ENV["INDICATIVE_API_KEY"],
          eventName: "Confirmed account",
          eventUniqueId: user.id,
          properties: {
              ref: user.referral,
          }
      }.to_json
      
      response = HTTParty.post(
        "#{@api}/event",
        :headers => { "Content-Type" => "application/json" },
        :body => body
      )
    end

    def self.played_contest user:
      body = {
          apiKey: ENV["INDICATIVE_API_KEY"],
          eventName: "Played contest",
          eventUniqueId: user.id,
          properties: {
              ref: user.referral,
          }
      }.to_json
      
      response = HTTParty.post(
        "#{@api}/event",
        :headers => { "Content-Type" => "application/json" },
        :body => body
      )
    end

    def self.referred_friend user:
      body = {
          apiKey: ENV["INDICATIVE_API_KEY"],
          eventName: "Referred friend",
          eventUniqueId: user.id,
          properties: {
              ref: user.referral,
          }
      }.to_json
      
      response = HTTParty.post(
        "#{@api}/event",
        :headers => { "Content-Type" => "application/json" },
        :body => body
      )
    end

  end
end
