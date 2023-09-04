class Dmv
  attr_reader :facilities

  def initialize
    @facilities = []
  end

  def add_facility(facility)
    @facilities << facility
  end

  def facilities_offering_service(service)
    facilities_list = []
    @facilities.each do |facility|
      if facility.services.include?(service)
        facilities_list << facility
      end
    end
    facilities_list
  end
end
