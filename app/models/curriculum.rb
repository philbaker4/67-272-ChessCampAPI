class Curriculum < ApplicationRecord

  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods



  # relationships
  has_many :camps

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  ratings_array = [0] + (100..3000).to_a
  validates :min_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validates :max_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validate :max_rating_greater_than_min_rating

  # scopes
  scope :alphabetical, -> { order('name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :for_rating, ->(rating) { where("min_rating <= ? and max_rating >= ?", rating, rating) }




# don't allow any curriculums to be destroyed
  before_destroy do 
    cannot_destroy_object()
  end

  # convert destroy call to make inactive
  after_rollback :deactive_camps

  private

  def max_rating_greater_than_min_rating
    # only testing 'greater than' in this method, so...
    return true if self.max_rating.nil? || self.min_rating.nil?
    unless self.max_rating > self.min_rating
      errors.add(:max_rating, "must be greater than the minimum rating")
    end
  end
 
 


  def deactive_camps
    return true unless self.destroyable == false

    deactiveable = true
    self.camps.upcoming.each do |c|
      if !c.registrations.empty?
        deactiveable = false
        break 
      end
    end

    if deactiveable
      self.make_inactive
    end
  end

end
