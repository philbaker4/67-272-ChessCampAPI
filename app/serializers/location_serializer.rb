class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active, :past_camps , :upcoming_camps

  
  def past_camps
    pc = Array.new
    object.camps.past.each do |c|
      pc << LocationCampSerializer.new(c)
    end
    pc
  end

  def upcoming_camps
    uc = Array.new
    object.camps.upcoming.each do |c|
      uc << LocationCampSerializer.new(c)
    end
    uc
  end

end
