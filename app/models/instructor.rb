class Instructor < ApplicationRecord

  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods


  # relationships
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors
  belongs_to :user
  # validations
  validates_presence_of :first_name, :last_name
  

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :needs_bio, -> { where('bio IS NULL') }
  # scope :needs_bio, -> { where(bio: nil) }  # this also works...

  # class methods
  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    CampInstructor.where(camp_id: camp.id).map{ |ci| ci.instructor }
    # the easy way... 
    # camp.instructors
  end

  # callbacks
  before_save :instructor_made_inactive, unless: :active
  before_destroy :check_if_destroyable
  after_destroy :destroy_user
  after_rollback :convert_to_inactive

  

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  private



  def check_if_destroyable
    cannot_destroy_object() unless self.camps.past.empty? 
    return true 
  end

  def convert_to_inactive
    return true unless self.destroyable == false
    
    make_user_inactive()
    remove_upcoming_camps()
    self.make_inactive
  end

  def instructor_made_inactive
    make_user_inactive()
    remove_upcoming_camps()


  end

  def make_user_inactive
    self.user.make_inactive
  end


  def remove_upcoming_camps
    upcomingCamps = self.camps.upcoming
    self.camp_instructors.each do |ci|
      ci.destroy if upcomingCamps.include? ci.camp
    end
  end


  def destroy_user
    self.user.destroy unless self.user.nil?
  end

end

