require './lib/vehicle'
require './lib/dmv_data_service'

class VechicleFactory
  attr_reader :vehicles
  def initialize
    @vehicles = []
  end

  def create_vehicles(registrations)
    registrations.each do |registration|
      vehicle = Vehicle.new({
        :vin => registration[:vin_1_10],
        :year => registration[:mode_year],
        :make => registration[:make],
        :model => registration[:model],
        :engine => :ev # registration[:],
      })
      vehicles << vehicle
    end
  end
end