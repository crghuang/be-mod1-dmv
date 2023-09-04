class Facility
  attr_reader :name,
              :address,
              :phone,
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(attributes = {})
    @name                 = attributes[:name]
    @address              = attributes[:address]
    @phone                = attributes[:phone]
    @services             = []
    @registered_vehicles  = []
    @collected_fees       = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include? "Vehicle Registration"
      if vehicle.antique?
        @collected_fees += 25
        vehicle.plate_type = :antique
      elsif vehicle.electric_vehicle?
        @collected_fees += 200
        vehicle.plate_type = :ev
      else
        @collected_fees += 100
        vehicle.plate_type = :regular
      end

      vehicle.registration_date = Date.today
      registered_vehicles << vehicle
    end
  end

  def administer_written_test(registrant)
    return false if !((@services.include? "Written Test") && registrant.age >= 16 && registrant.permit?)
    registrant.license_data[:written] = true
  end

  def administer_road_test(registrant)
    return false if !((@services.include? "Road Test") && registrant.license_data[:written])
    registrant.license_data[:license] = true
  end
  
  def renew_drivers_license(registrant)
    return false if !((@services.include? "Renew License") && registrant.license_data[:license])
    registrant.license_data[:renewed] = true
  end
end
