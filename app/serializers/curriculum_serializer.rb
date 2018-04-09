class CurriculumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :min_rating, :max_rating, :active, :past_camps, :upcoming_camps
  

  def past_camps
    pc = Array.new
    object.camps.past.each do |c|
      pc << CurriculumCampSerializer.new(c)
    end
    pc
  end

  def upcoming_camps
    uc = Array.new
    object.camps.upcoming.each do |c|
      uc << CurriculumCampSerializer.new(c)
    end
    uc
  end

  

end
