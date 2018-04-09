class Family < ApplicationRecord

  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods



  belongs_to :user
  has_many :students
  has_many :registrations, through: :students


  validates_presence_of :family_name, :parent_first_name



  # scopes
  scope :alphabetical, -> { order('family_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  

  # don't allow any family to be destroyed
  before_destroy do 
    cannot_destroy_object()
  end

  after_rollback :deactive_family
  before_save :user_deactive_family, unless: :active
  # handles when the use makes the family inactive
  



  private


  def user_deactive_family
    self.user.make_inactive
    remove_upcoming_registrations()
    make_students_inactive()
  end

  def deactive_family
    return true unless self.destroyable == false
    self.user.make_inactive 
    remove_upcoming_registrations()
    make_students_inactive()
    self.make_inactive
  end




  def remove_upcoming_registrations

    upcoming_camps = Camp.upcoming
    self.registrations.each do |r|
      r.destroy if upcoming_camps.include? r.camp

    end
  end

  def make_students_inactive 
    self.students.each { |s| s.make_inactive }
  end

end
  