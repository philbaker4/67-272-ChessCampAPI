class CampSerializer < ActiveModel::Serializer
  attributes :id, :curriculum, :location, :instructors, :cost, :start_date, :end_date, :time_slot, :max_students, :is_open, :open_spots, :active


  def is_open 
    !object.is_full?
  end
  def open_spots 
    object.max_students - object.registrations.size
  end

  def location 
    CampLocationSerializer.new(object.location)
  end
  def curriculum 
    CampCurriculumSerializer.new(object.curriculum)
  end

  def instructors 
    issss = Array.new
    object.instructors.each do |i|
       issss << CampInstructorsSerializer.new(i)
    end
    issss

  end


end
