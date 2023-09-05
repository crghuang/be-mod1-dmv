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

  def create_facilities(facilities)
    facilities_list = []
    facilities.map do |facility|
      case facility[:state]
      when "CO"
        name = facility[:dmv_office]
        address = [
            facility[:address_li],
            facility[:address__1],
            facility[:city],
            facility[:state],
            facility[:zip]
          ].join(" ")
        phone = facility[:phone]
        services = facility[:services_p].split(/(,|;)\s*/)

      when "NY"
        name = facility[:office_name]
        address = [
            facility[:street_address_line_1],
            facility[:city],
            facility[:state],
            facility[:zip_code]
          ].join(" ")
        phone = facility[:public_phone_number]
        services = []

      when "MO"
        name = facility[:name]
        address = [
            facility[:address1],
            facility[:city],
            facility[:state],
            facility[:zipcode]
          ].join(" ")
        phone = facility[:phone]
        services = []
      
      else
        name = ""
        address = ""
        phone = ""
        services = []
      end

      # ** Note: Create var for facility, run 'add_service' for full list before appending to facilities list
      # services.each { |service| add_service(service) } if !services.empty?

      facilities_list << Facility.new({
        :name     => name,
        :address  => address,
        :phone    => phone
      })
    end
    facilities_list
  end
end
