require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})

    # Create facility, vehicle instances
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
      
    # Create registrant instances
    @registrant_1 = Registrant.new('Bruce', 18, true )
    @registrant_2 = Registrant.new('Penny', 16 )
    @registrant_3 = Registrant.new('Tucker', 15 )
  
    # Written test
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('DMV Tremont Branch')
      expect(@facility.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility.phone).to eq('(720) 865-4600')
      expect(@facility.services).to eq([])

      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_2).to be_an_instance_of(Facility)
      expect(@cruz).to be_an_instance_of(Vehicle)
      expect(@bolt).to be_an_instance_of(Vehicle)
      expect(@camaro).to be_an_instance_of(Vehicle)
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])

      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(["Vehicle Registration"])
    end
  end

  describe '#register vehicle' do
    it 'can register vehicles' do
      @facility_1.add_service('Vehicle Registration')
      expect(@cruz.registration_date).to eq(nil)
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)
      
      # Register several vehicles
      @facility_1.register_vehicle(@cruz)
      expect(@cruz.registration_date).to be_a_kind_of(Date)
      expect(@cruz.plate_type).to eq(:regular)
      expect(@facility_1.registered_vehicles).to match_array([Vehicle])
      expect(@facility_1.collected_fees).to eq(100)

      @facility_1.register_vehicle(@camaro)
      expect(@camaro.registration_date).to be_a_kind_of(Date)
      expect(@camaro.plate_type).to eq(:antique)
      
      @facility_1.register_vehicle(@bolt)
      expect(@bolt.registration_date).to be_a_kind_of(Date)
      expect(@bolt.plate_type).to eq(:ev)

      expect(@facility_1.registered_vehicles).to match_array([Vehicle, Vehicle, Vehicle])

      expect(@facility_1.collected_fees).to eq(325)

      # Try to register without availabe service
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.services).to eq([])
      @facility_2.register_vehicle(@bolt)
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.collected_fees).to eq(0)
    end
  end

  describe '#administer written test' do
    it 'can administer written tests' do
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      expect(@registrant_1.permit?).to eq(true)
      expect(@facility_1.administer_written_test(@registrant_1)).to eq(false)
      @facility_1.add_service('Written Test')
      expect(@facility_1.administer_written_test(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      expect(@registrant_2.age).to eq(16)
      expect(@registrant_2.permit?).to eq(false)
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(false)
      expect(@registrant_2.age).to eq(16)
      expect(@registrant_2.permit?).to eq(false)
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(false)
      @registrant_2.earn_permit
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      expect(@registrant_3.age).to eq(15)
      expect(@registrant_3.permit?).to eq(false)
      expect(@facility_1.administer_written_test(@registrant_3)).to eq(false)
      @registrant_3.earn_permit
      expect(@facility_1.administer_written_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end

  describe '#administer road test' do
    it 'can administer road tests' do
      @facility_1.add_service('Written Test')

      # Registrant 3
      expect(@facility_1.administer_road_test(@registrant_3)).to eq(false)
      @registrant_3.earn_permit
      expect(@facility_1.administer_road_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})

      # Registrant 1
      expect(@facility_1.administer_road_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Road Test')
      expect(@facility_1.services).to match_array(["Written Test", "Road Test"])

      @facility_1.administer_written_test(@registrant_1)
      expect(@facility_1.administer_road_test(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})

      # Registrant 2
      @registrant_2.earn_permit
      @facility_1.administer_written_test(@registrant_2)
      expect(@facility_1.administer_road_test(@registrant_2)).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
    end
  end

  describe '#renew license' do
    it 'can administer renew licenses' do
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')

      # Registrant 1
      @facility_1.administer_written_test(@registrant_1)
      @facility_1.administer_road_test(@registrant_1)
      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(false)
      @facility_1.add_service('Renew License')
      expect(@facility_1.services).to match_array(["Written Test", "Road Test", "Renew License"])
      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})

      # Registrant 3
      @registrant_3.earn_permit
      expect(@facility_1.renew_drivers_license(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      
      # Registrant 2
      @registrant_2.earn_permit
      @facility_1.administer_written_test(@registrant_2)
      @facility_1.administer_road_test(@registrant_2)
      expect(@facility_1.renew_drivers_license(@registrant_2)).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
    end
  end
end
