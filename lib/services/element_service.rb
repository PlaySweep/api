module ElementService
  class Referral
    def initialize user:
      @user = user
    end

    def run
      create_entry
    end

    def create_entry
      for_referrer
      for_referred
    end

    def entry_element
      SlateElement.find_by(category: "Entry")
    end

    def for_referrer
      puts "Create Entry for referrer: #{@user.referred_by}"
      @user.referred_by.elements.create(element_id: entry_element.id)
    end

    def for_referred
      puts "Create Entry for referred: #{@user}"
      @user.elements.create(element_id: entry_element.id)
    end
  end

  class Sweep
    def initialize user:
      @user = user
    end

    def run
      create_entry
    end

    def create_entry
      for_sweep
    end

    def entry_element
      SlateElement.find_by(category: "Entry")
    end

    def for_sweep
      puts "Create Entry for sweep: #{@user}"
      @user.elements.create(element_id: entry_element.id)
    end
  end
end