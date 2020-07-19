class DataMigration

  def create_owner_contests
    ids = [11, 16, 13, 2]
    owners = Team.active.where.not id: ids
    owners.each do |owner|
      contest = Contest.new
      contest_name = owner.name.split(' ')[-1]
      contest.name = contest_name
      contest.account_id = 1
      contest.status = 1
      contest.save
      image_name = owner.name.split(' ').map(&:downcase!).join('_')
      image_url = "https://budweiser-sweep-assets.s3.amazonaws.com/#{image_name}_bud_entry.png"
      contest.images.create(description: "Default Lockup", category: "Default", url: image_url)
    end
  end

  def self.update_skus
    Sku.all.each do |sku|
      code = sku.product.owner_id ? "#{sku.product.owner.account.code_prefix}#{sku.code}" : "#{Account.first.code_prefix}#{sku.code}"
      sku.code = code
      sku.save
    end
  end

  def self.upload_copy category:, message:
    tenants = %w[budweiser budlight]
    tenants.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        account = Account.find_by(tenant: tenant)
        account.copies.create(type: "Copy", category: category, message: message)
      end
    end
  end


  def self.update_gender tenant:
    Apartment::Tenant.switch(tenant) do
      User.all.each do |user|
        response = HTTParty.get("https://api.genderize.io/?name=#{user.first_name}")
        json_response = JSON.parse(response.body)
        user.update_attributes(gender: json_response["gender"]) if user.gender.nil? and json_response["probability"] > 0.75
      end
    end
  end

  def remove_dups tenant:, user:
    Apartment::Tenant.switch(tenant) do
      ids = user.picks.select(:event_id).group(:event_id).having("count(*) > 1")
      duplicates = user.picks.where(event_id: ids)
      if duplicates.length == 2
        duplicates.last.destroy
      else
        puts "NOT 2!"
      end
    end
  end

  def self.fetch_go_puff
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'correct_csv.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: "ISO-8859-1")
    players = []
    csv.each do |row|
      players.push({date: row["Date"], email: row["Email"], name: row["Name"], zip: row["Zipcode"], source: row["Source"]})
    end
    players
  end

  def self.create_playing_rules
    first_states = [["IN", "Indiana"], ["MA", "Massachusetts"], ["ME", "Maine"], ["MN", "Minnesota"], ["NC", "North Carolina"], ["NJ", "New Jersey"], ["VA", "Virginia"], ["WA", "Washington"]]
    second_states = [["AZ", "Arizona"], ["CO", "Colorado"], ["DC", "District of Columbia"], ["FL", "Florida"], ["IL", "Illinois"], ["KY", "Kentucky"], ["MD", "Maryland"], ["NY", "New York"], ["OR", "Oregon"], ["RI", "Rhode Island"], ["TN", "Tennessee"], ["WY", "Wyoming"]]
    first_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Playing", eligible: false, level: 1)
    end
    second_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Playing", eligible: false, level: 2)
    end
  end

  def self.create_sweep_rules
    first_states = [["IN", "Indiana"], ["MA", "Massachusetts"], ["ME", "Maine"], ["MN", "Minnesota"], ["NC", "North Carolina"], ["NJ", "New Jersey"], ["VA", "Virginia"], ["WA", "Washington"]]
    second_states = [["AZ", "Arizona"], ["CO", "Colorado"], ["DC", "District of Columbia"], ["FL", "Florida"], ["IL", "Illinois"], ["KY", "Kentucky"], ["MD", "Maryland"], ["NY", "New York"], ["OR", "Oregon"], ["RI", "Rhode Island"], ["TN", "Tennessee"], ["WY", "Wyoming"]]
    first_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Sweep", eligible: false, level: 0)
    end
    second_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Sweep", eligible: false, level: 1)
    end
  end

  def self.upload_quizzes
    csv_text = File.read(Rails.root.join('lib', 'seeds', "quizzes.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      quiz = Quiz.new
      sku = Sku.find_by(id: row["sku_id"])
      quiz.id = row["id"]
      quiz.name = row["name"]
      quiz.owner_id = row["team_id"]
      quiz.start_time = row["start_time"]
      quiz.end_time = row["end_time"]
      quiz.save
      quiz.prizes.create(product_id: sku.product_id, sku_id: sku.id) if sku
    end
  end

  def self.upload_questions
    csv_text = File.read(Rails.root.join('lib', 'seeds', "questions.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each do |row|
      question = Question.new
      question.id = row["id"]
      question.type = "Question"
      question.description = row["description"]
      question.order = row["order"]
      question.quiz_id = row["quiz_id"]
      question.save
    end
  end

  def self.upload_answers
    csv_text = File.read(Rails.root.join('lib', 'seeds', "answers.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each do |row|
      answer = Answer.new
      answer.id = row["id"]
      answer.description = row["description"]
      answer.order = row["order"]
      answer.status = row["status"].to_i
      answer.question_id = row["question_id"]
      answer.save
    end
  end

  def self.upload_data
    self.upload_quizzes
    self.upload_questions
    self.upload_answers
  end

  def self.upload_profiles
    csv_text = File.read(Rails.root.join('lib', 'seeds', "profiles.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      profile = Profile.new
      profile.first_name = row["first_name"]
      profile.last_name = row["last_name"]
      profile.owner_id = row["owner_id"]
      profile.save
    end
  end

  def self.upload_slates
    csv_text = File.read(Rails.root.join('lib', 'seeds', "slates.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      slate = Slate.new
      sku = Sku.find_by(id: row["sku_id"])
      slate.id = row["id"]
      slate.name = row["name"]
      slate.type = "Slate"
      slate.start_time = row["start_time"]
      slate.owner_id = row["owner_id"]
      slate.contest_id = row["contest_id"]
      slate.save
      slate.prizes.create(product_id: sku.product_id, sku_id: sku.id) if sku
    end
  end

  def self.upload_participants
    csv_text = File.read(Rails.root.join('lib', 'seeds', "participants.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      participant = Participant.new
      participant.id = row["id"]
      participant.slate_id = row["slate_id"]
      participant.owner_id = row["owner_id"]
      participant.field = row["field"]
      participant.save
    end
  end

  def self.upload_events
    csv_text = File.read(Rails.root.join('lib', 'seeds', "events.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each do |row|
      event = Event.new
      event.id = row["id"]
      event.type = "Event"
      event.description = row["description"]
      event.details = row["details"]
      event.category = row["category"]
      event.order = row["order"]
      event.slate_id = row["slate_id"]
      event.save
    end
  end

  def self.upload_selections
    csv_text = File.read(Rails.root.join('lib', 'seeds', "selections.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each do |row|
      selection = Selection.new
      selection.id = row["id"]
      selection.description = row["description"]
      selection.order = row["order"]
      selection.event_id = row["event_id"]
      selection.category = row["category"]
      selection.save
    end
  end

  def self.upload_drizly_promotions name:, category:, value:, level:
    csv_text = File.read(Rails.root.join('lib', 'seeds', "#{name}_promo.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      t = DrizlyPromotion.new
      t.category = category
      t.code = row["redemption_code"]
      t.value = value
      t.level = level
      t.save
    end
  end

  def self.seed_leaderboard_results leaderboard:, history:
    board = Board.fetch(leaderboard: leaderboard)
    board.all_members.each do |player|
      user = User.find_by(id: player[:member])
      if user
        user.leaderboard_results.find_or_create_by(leaderboard_history_id: history.id, score: player[:score], rank: player[:rank])
      end
    end
  end

  def api_object user:
    current_age = age(user.dob)
    user_object = {
      "id*": user.id.to_s,
      "source_consumer_id*": "budlight_#{user.id}",
      "contact_channel": "",
      "consumer_type": "",
      "consumer_type_2": "",
      "personal_information": {
        "first_name*": user.first_name || "",
        "middle_name": "",
        "last_name*": user.last_name || "",
        "birth_date*": user.dob || "",
        "age": current_age.to_s || "",
        "age_range": "",
        "above_lda": "Y",
        "gender": user.gender || ""
      },
      "contact_information": {
        "email": {
          "email_primary*": user.email || "",
          "email_primary_verified": user.email || "",
          "email_personal": "",
          "email_work": "",
          "email_other": ""
        },
        "phone": {
          "primary*": "",
          "work": "",
          "home": "",
          "mobile": ""
        },
        "address": {
          "home": {
            "address_line_1": user.line1 || "",
            "address_line_2": user.line2 || "",
            "address_line_3": "",
            "city": user.city || "",
            "state": user.state || "",
            "zip5": user.zipcode || "",
            "zip9": "",
            "country*": "US"
          }
        }
      },
      "social_information": {
        "facebook_id": user.facebook_uuid || "",
        "facebook_profile_url": user.profile_pic || "",
        "facebook_friends": "",
        "twitter_id": "",
        "twitter_handle": "",
        "twitter_profile_url": "",
        "tw_followers_cnt": "",
        "tw_following_cnt": ""
      },
      "brand_opted_in*": "Y",
      "corp_opted_in*": "Y",
      "airline_preferred": "",
      "language_preferred": "en",
      "education_level": "",
      "occupation": "",
      "source_consumer_created*": user.created_at.strftime("%Y-%m-%d"),
      "source_consumer_updated": "",
      "additional_information": {}
    }.to_json
    user_object.delete!("//")
    puts user_object + ","
    puts "\n"
  end

  def map_api_object users:
    users.each { |user| api_object(user: user) }
  end

  def data_api_formatter users:
    formatted_users = users.map do |user|
      current_age = age(user.dob)
      {
        "id*": user.id,
        "source_consumer_id*": "budlight_#{user.id}",
        "contact_channel": "",
        "consumer_type": "",
        "consumer_type_2": "",
        "personal_information": {
          "first_name*": user.first_name || "",
          "middle_name": "",
          "last_name*": user.last_name || "",
          "birth_date*": user.dob || "",
          "age": current_age || "",
          "age_range": "",
          "above_lda": "Y",
          "gender": user.gender || ""
        },
        "contact_information": {
          "email": {
            "email_primary*": user.email || "",
            "email_primary_verified": user.email || "",
            "email_personal": "",
            "email_work": "",
            "email_other": ""
          },
          "phone": {
            "primary*": "",
            "work": "",
            "home": "",
            "mobile": ""
          },
          "address": {
            "home": {
              "address_line_1": user.line1 || "",
              "address_line_2": user.line2 || "",
              "address_line_3": "",
              "city": user.city || "",
              "state": user.state || "",
              "zip5": user.zipcode || "",
              "zip9": "",
              "country*": "US"
            }
          }
        },
        "social_information": {
          "facebook_id": user.facebook_uuid || "",
          "facebook_profile_url": user.profile_pic || "",
          "facebook_friends": "",
          "twitter_id": "",
          "twitter_handle": "",
          "twitter_profile_url": "",
          "tw_followers_cnt": "",
          "tw_following_cnt": ""
        },
        "brand_opted_in*": "Y",
        "corp_opted_in*": "",
        "airline_preferred": "",
        "language_preferred": "en",
        "education_level": "",
        "occupation": "",
        "source_consumer_created*": "",
        "source_consumer_updated": "",
        "additional_information": ""
      }
    end

    return { "real_time_flag*": "N", "consumer_profiles": formatted_users, "events": [{
      "id*": "10418",
      "event_information": {
        "source_event_id*": "BUDA-8574-10418-BUD",
        "type": "",
        "event_name*": "Event_BUDA-8574-10418-BUD",
        "event_description": "",
        "event_location": "",
        "event_start_timestamp": "",
        "event_end_timestamp": ""
      },
      "location_information": {
        "address_line_1": "",
        "address_line_2": "",
        "address_line_3": "",
        "city": "",
        "state": "",
        "zip": "",
        "country": ""
      },
      "contact_information": {
        "event_rep_name": "",
        "event_rep_email": "",
        "event_rep_phone": ""
      },
      "source_event_created*": "#{Time.now.strftime("%Y-%m-%d")}",
      "source_event_updated": "#{Time.now.strftime("%Y-%m-%d")}",
      "additional_information": {

      }
    }]  }
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def fetch_lookalike_audience
    users = User.joins(:cards).group('users.id').order("count(users.id) DESC").first(3000)
    CSV.open("#{Rails.root}/tmp/lookalike_audience.csv", "wb") do |csv|
      csv << ["Email", "First Name", "Last Name", "Zipcode", "City", "State", "Country", "DOB", "DOBY", "Gender", "Age", "Facebook ID"]
      users.each do |user|
        csv << [user.email, user.first_name, user.last_name, user.zipcode, user.location.city, user.location.state, "United States", user.dob, user.dob.year, user.gender, age(user.dob), "_#{user.facebook_uuid}"]
      end
    end
  end

  def self.migrate_to_participants slate:
    if slate.opponent_id
      if slate.field == "home"
        slate.participants.create(owner_id: slate.owner_id, slate_id: slate.id, field: "home")
        slate.participants.create(owner_id: slate.opponent_id, slate_id: slate.id, field: "away")
      else
        slate.participants.create(owner_id: slate.owner_id, slate_id: slate.id, field: "away")
        slate.participants.create(owner_id: slate.opponent_id, slate_id: slate.id, field: "home")
      end
    else
      slate.participants.create(owner_id: slate.owner_id, slate_id: slate.id)
    end
  end

  def manual_upload
    slate = Slate.create(name: "Los Angeles Dodgers", contest_id: 4, owner_id: 2, start_time: DateTime.current + 5.days)

    e1 = slate.events.create(order: 1, description: "Will the Dodgers record three or more extra-base hits?", category: "Offense")
    e2 = slate.events.create(order: 2, description: "Will the Dodgers hitters record 8 or more hits?", category: "Offense")
    e3 = slate.events.create(order: 3, description: "Will the Dodgers win?", category: "Outcome")
    
    e1.selections.create(order: 1, description: "Yes, the Dodgers will record three or more extra-base hits", category: "Positive")
    e1.selections.create(order: 2, description: "No", category: "Negative")
    
    e2.selections.create(order: 1, description: "Yes, the Dodgers hitters will record 8 or more hits", category: "Positive")
    e2.selections.create(order: 2, description: "No", category: "Negative")
    
    e3.selections.create(order: 1, description: "Yes, the Dodgers will win", category: "Positive")
    e3.selections.create(order: 2, description: "No", category: "Negative")
  end
end