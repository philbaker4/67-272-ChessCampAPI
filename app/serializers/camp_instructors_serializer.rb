class CampInstructorsSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :email, :phone, :active

  def email 
    object.user.email
  end

  def phone
    object.user.phone
  end

end
