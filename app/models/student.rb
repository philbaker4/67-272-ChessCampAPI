class Student < ApplicationRecord 

  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  belongs_to :family
  has_many :registrations
  has_many :camps, through: :registrations



  scope :chronological, -> { order('start_date','end_date') }
  scope :morning, -> { where('time_slot = ?','am') }
  scope :afternoon, -> { where('time_slot = ?','pm') }
  scope :upcoming, -> { where('start_date >= ?', Date.today) }
  scope :past, -> { where('end_date < ?', Date.today) }
  scope :for_curriculum, ->(curriculum_id) { where("curriculum_id = ?", curriculum_id) }
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :below_rating, ->(ceiling) { where("rating < ? ", ceiling) }
  scope :at_or_above_rating, ->(floor) { where("rating >= ? ", floor) }


  ratings_array = [0] + (100..3000).to_a

  validates_presence_of :first_name, :last_name, :family_id
  validates :rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }, allow_blank: :true
  validates_date :date_of_birth, :on_or_before => Date.today, allow_blank: true
  validates_numericality_of :family_id, only_integer: true, greater_than: 0


  before_save :adjust_rating
  before_save :remove_upcoming_registrations, unless: :active
  before_destroy :check_if_destroyable
  after_rollback :deactive_student


  def name 
    last_name + ", " + first_name
  end

  def proper_name
    first_name + " " + last_name
  end

  def age
    age  = Date.today.year - self.date_of_birth.year
    if Date.today.month <= self.date_of_birth.month and Date.today.day < self.date_of_birth.day
      age = age - 1
    end
    age
  end

  private

  def adjust_rating
    if self.rating.nil?
      self.rating = 0
    end
  end

  def check_if_destroyable
    registrations = self.registrations.all.map{|r| r.camp_id}
    self.destroyable = true
    self.camps.past.each do |c|
      if registrations.include? c.id
        cannot_destroy_object()
      end
    end

    remove_upcoming_registrations()
  end

  def deactive_student
    return true unless self.destroyable == false
    self.make_inactive
    remove_upcoming_registrations()
  end




  def remove_upcoming_registrations

    upcoming_camps = Camp.upcoming
    self.registrations.each do |r|
      r.destroy if upcoming_camps.include? r.camp

    end
  end






end
