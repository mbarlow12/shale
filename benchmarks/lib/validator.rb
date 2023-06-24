module Validator
  class << self
    def validate!(hand, fido)
      valid?(hand.people.length, fido.people.length)

      hand.people.each_with_index do |hand_person, idx|
        validate_person(hand_person, fido.people[idx])
      end
    end

    def validate_person(hand, fido)
      valid?(hand.first_name, fido.first_name)
      valid?(hand.last_name, fido.last_name)
      valid?(hand.middle_name, fido.middle_name)
      valid?(hand.prefix, fido.prefix)
      valid?(hand.date_of_birth, fido.date_of_birth)
      validate_address(hand.place_of_birth, fido.place_of_birth)
      valid?(hand.driving_license, fido.driving_license)
      valid?(hand.hobbies, fido.hobbies)

      valid?(hand.education.length, fido.education.length)
      hand.education.each_with_index do |hand_school, idx|
        validate_school(hand_school, fido.education[idx])
      end

      validate_address(hand.current_address, fido.current_address)

      valid?(hand.past_addresses.length, fido.past_addresses.length)
      hand.past_addresses.each_with_index do |hand_address, idx|
        validate_address(hand_address, fido.past_addresses[idx])
      end

      valid?(hand.contacts.length, fido.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, fido.contacts[idx])
      end

      validate_bank_account(hand.bank_acocunt, fido.bank_acocunt)
      validate_car(hand.current_car, fido.current_car)

      valid?(hand.cars.length, fido.cars.length)
      hand.cars.each_with_index do |hand_car, idx|
        validate_car(hand_car, fido.cars[idx])
      end

      validate_job(hand.current_job, fido.current_job)

      valid?(hand.jobs.length, fido.jobs.length)
      hand.jobs.each_with_index do |hand_job, idx|
        validate_job(hand_job, fido.jobs[idx])
      end

      valid?(hand.pets.length, fido.pets.length)
      hand.pets.each_with_index do |hand_pet, idx|
        validate_animal(hand_pet, fido.pets[idx])
      end

      valid?(hand.children.length, fido.children.length)
      hand.children.each_with_index do |hand_child, idx|
        validate_person(hand_child, fido.children[idx])
      end
    end

    def validate_animal(hand, fido)
      valid?(hand.kind, fido.kind)
      valid?(hand.breed, fido.breed)
      valid?(hand.name, fido.name)
    end

    def validate_job(hand, fido)
      valid?(hand.title, fido.title)
      valid?(hand.field, fido.field)
      valid?(hand.seniority, fido.seniority)
      valid?(hand.position, fido.position)
      valid?(hand.employment_type, fido.employment_type)
      validate_company(hand.company, fido.company)
    end

    def validate_car(hand, fido)
      valid?(hand.model, fido.model)
      valid?(hand.brand, fido.brand)
      validate_company(hand.manufacturer, fido.manufacturer)
    end

    def validate_bank_account(hand, fido)
      valid?(hand.number, fido.number)
      valid?(hand.balance, fido.balance)
      validate_company(hand.bank, fido.bank)
    end

    def validate_company(hand, fido)
      valid?(hand.name, fido.name)
      valid?(hand.industry, fido.industry)
      valid?(hand.ein, fido.ein)
      valid?(hand.type, fido.type)
      validate_address(hand.address, fido.address)

      valid?(hand.contacts.length, fido.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, fido.contacts[idx])
      end
    end

    def validate_school(hand, fido)
      valid?(hand.name, fido.name)
      validate_address(hand.address, fido.address)

      valid?(hand.contacts.length, fido.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, fido.contacts[idx])
      end
    end

    def validate_contact(hand, fido)
      valid?(hand.type, fido.type)
      valid?(hand.contact, fido.contact)
    end

    def validate_address(hand, fido)
      valid?(hand.city, fido.city)
      valid?(hand.street, fido.street)
      valid?(hand.zip, fido.zip)
      valid?(hand.state, fido.state)
      valid?(hand.state_abbr, fido.state_abbr)
      valid?(hand.country, fido.country)
      valid?(hand.country_code, fido.country_code)
      valid?(hand.time_zone, fido.time_zone)
      valid?(hand.latitude, fido.latitude)
      valid?(hand.longitude, fido.longitude)
    end

    def valid?(a, b)
      raise "#{a} != #{b}" if a != b
    end
  end
end
