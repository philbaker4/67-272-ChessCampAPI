class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :user, :past_camps, :upcoming_camps

  def user 
    InstructorUserSerializer.new(object.user)
  end

  def past_camps
    pc = Array.new
    object.camps.past.each do |c|
      pc << InstructorCampSerializer.new(c)
    end
    pc
  end

  def upcoming_camps
    uc = Array.new
    object.camps.upcoming.each do |c|
      uc << InstructorCampSerializer.new(c)
    end
    uc
  end
  attributes :active
end
