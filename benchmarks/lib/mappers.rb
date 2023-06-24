require 'fido'
require_relative 'models'

class AddressMapper < Fido::Mapper
  model Address

  attribute :city, Fido::Type::Value
  attribute :street, Fido::Type::Value
  attribute :zip, Fido::Type::Value
  attribute :state, Fido::Type::Value
  attribute :state_abbr, Fido::Type::Value
  attribute :country, Fido::Type::Value
  attribute :country_code, Fido::Type::Value
  attribute :time_zone, Fido::Type::Value
  attribute :latitude, Fido::Type::Value
  attribute :longitude, Fido::Type::Value
end

class ContactMapper < Fido::Mapper
  model Contact

  attribute :type, Fido::Type::Value
  attribute :contact, Fido::Type::Value
end

class CompanyMapper < Fido::Mapper
  model Company

  attribute :name, Fido::Type::Value
  attribute :industry, Fido::Type::Value
  attribute :ein, Fido::Type::Value
  attribute :type, Fido::Type::Value
  attribute :address, AddressMapper
  attribute :contacts, ContactMapper, collection: true

  xml do
    root 'company'
    map_element 'name', to: :name
    map_element 'industry', to: :industry
    map_element 'ein', to: :ein
    map_element 'type', to: :type
    map_element 'address', to: :address
    map_element 'contact', to: :contacts
  end
end

class CarMapper < Fido::Mapper
  model Car

  attribute :model, Fido::Type::Value
  attribute :brand, Fido::Type::Value
  attribute :manufacturer, CompanyMapper
end

class BankAccountMapper < Fido::Mapper
  model BankAccount

  attribute :number, Fido::Type::Value
  attribute :balance, Fido::Type::Value
  attribute :bank, CompanyMapper
end

class SchoolMapper < Fido::Mapper
  model School

  attribute :name, Fido::Type::Value
  attribute :address, AddressMapper
  attribute :contacts, ContactMapper, collection: true

  xml do
    root 'school'
    map_element 'name', to: :name
    map_element 'address', to: :address
    map_element 'contact', to: :contacts
  end
end

class JobMapper < Fido::Mapper
  model Job

  attribute :title, Fido::Type::Value
  attribute :field, Fido::Type::Value
  attribute :seniority, Fido::Type::Value
  attribute :position, Fido::Type::Value
  attribute :employment_type, Fido::Type::Value
  attribute :company, CompanyMapper
end

class AnimalMapper < Fido::Mapper
  model Animal

  attribute :kind, Fido::Type::Value
  attribute :breed, Fido::Type::Value
  attribute :name, Fido::Type::Value
end

class PersonMapper < Fido::Mapper
  model Person

  attribute :first_name, Fido::Type::Value
  attribute :last_name, Fido::Type::Value
  attribute :middle_name, Fido::Type::Value
  attribute :prefix, Fido::Type::Value
  attribute :date_of_birth, Fido::Type::Value
  attribute :place_of_birth, AddressMapper
  attribute :driving_license, Fido::Type::Value
  attribute :hobbies, Fido::Type::Value, collection: true
  attribute :education, SchoolMapper, collection: true
  attribute :current_address, AddressMapper
  attribute :past_addresses, AddressMapper, collection: true
  attribute :contacts, ContactMapper, collection: true
  attribute :bank_acocunt, BankAccountMapper
  attribute :current_car, CarMapper
  attribute :cars, CarMapper, collection: true
  attribute :current_job, JobMapper
  attribute :jobs, JobMapper, collection: true
  attribute :pets, AnimalMapper, collection: true
  attribute :children, PersonMapper, collection: true

  xml do
    root 'person'
    map_element 'first_name', to: :first_name
    map_element 'last_name', to: :last_name
    map_element 'middle_name', to: :middle_name
    map_element 'prefix', to: :prefix
    map_element 'date_of_birth', to: :date_of_birth
    map_element 'place_of_birth', to: :place_of_birth
    map_element 'driving_license', to: :driving_license
    map_element 'hobby', to: :hobbies
    map_element 'school', to: :education
    map_element 'current_address', to: :current_address
    map_element 'past_address', to: :past_addresses
    map_element 'contact', to: :contacts
    map_element 'bank_acocunt', to: :bank_acocunt
    map_element 'current_car', to: :current_car
    map_element 'car', to: :cars
    map_element 'current_job', to: :current_job
    map_element 'job', to: :jobs
    map_element 'pet', to: :pets
    map_element 'child', to: :children
  end
end

class ReportMapper < Fido::Mapper
  model Report

  attribute :people, PersonMapper, collection: true

  xml do
    root 'report'
    map_element 'person', to: :people
  end
end
