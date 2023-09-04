require 'spec_helper'

RSpec.describe VechicleFactory do
  before(:each) do
    @factory = VechicleFactory.new
    @wa_ev_registrations = DmvDataService.new.wa_ev_registrations
    @factory.create_vehicles(@wa_ev_registrations)
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@factory).to be_an_instance_of(VechicleFactory)
    end
  end

  describe '#create vehicles' do
    it 'can create instances of Vehicle populated from WA registrations' do
      expect(@factory.vehicles.include? Vehicle).to_not be(nil)
    end
  end
end