class Facility
  attr_reader :name, :address, :phone, :services

  def initialize(attributes = {})
    @name     = attributes[:name]
    @address  = attributes[:address]
    @phone    = attributes[:phone]
    @services = []
  end

  def add_service(service)
    @services << service
  end
end
