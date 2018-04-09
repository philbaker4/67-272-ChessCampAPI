

class Registration < ApplicationRecord

  belongs_to :camp
  belongs_to :student 

  attr_accessor :credit_card_number
  attr_accessor :expiration_year
  attr_accessor :expiration_month

  validates_presence_of :camp_id, :student_id
  validate  :student_is_active_in_the_system
  validate :camp_is_active_in_the_system
  validate :student_can_register_for_camp
  validates_numericality_of :camp_id, only_integer: true, greater_than: 0
  validates_numericality_of :student_id, only_integer: true, greater_than: 0

  validate :valid_cc_date
  validate :valid_cc_type


  scope :alphabetical, -> { joins(:student).order( "last_name, first_name") }
  scope :for_camp, ->(camp_id) { where("camp_id == ?", camp_id) }


 @@amex = CreditCardType.new('AMEX','^(34|37)\d{13}$' )
  @@dccb = CreditCardType.new('DCCB','^30[0-5]{1}\d{11}$' )
  @@disc = CreditCardType.new('DISC', '^(6011\d{12})$|^(65\d{14})$' )
  @@mc = CreditCardType.new('MC','^5[1-5]\d{14}$' )
  @@visa = CreditCardType.new('VISA', '^4\d{15}$|^4\d{12}$')
  @@cards = [@@amex, @@dccb, @@disc, @@mc, @@visa]

  def pay 
    return false unless self.payment.nil?
    card = CreditCard.new(credit_card_number, expiration_year, expiration_month)
    if !card.valid?
      errors.add(:registration, "Not all required credit card data is present")
      return false
    end

    paymentString = "camp: #{self.camp_id}; student: #{self.student_id}; amount_paid: #{self.camp.cost}; card: #{card.type.name}; ****#{card.number.to_s[-4..-1]}"

    encodedString = Base64.urlsafe_encode64(paymentString).to_s
    self.update_attribute(:payment, encodedString)
    return encodedString
  end
   

  private 
  def student_is_active_in_the_system
    return if self.student.nil?
    errors.add(:registration, "is not currently active") unless self.student.active
  end
  def camp_is_active_in_the_system
    return if self.camp.nil?
    errors.add(:registration, "is not currently active") unless self.camp.active
  end

 def student_can_register_for_camp
    return if self.student.nil? || self.camp.nil?
    if self.student.rating > self.camp.curriculum.max_rating || self.student.rating < self.camp.curriculum.min_rating
      errors.add(:registration, "rating is not within the proper range for this camp") 
    end

    Registration.where("student_id = ?", self.student_id).each do |reg|
      if self.id != reg.id and reg.camp.start_date == self.camp.start_date && reg.camp.time_slot == self.camp.time_slot
        errors.add(:registration, "is already enrolled in a camp at this time") 
      end
    end
  end

  def valid_cc_type

    return true if credit_card_number.nil?
    testCard = CreditCard.new(credit_card_number, 2020, 10)
    errors.add(:registration, "Not a valid credit card number") unless testCard.valid? 
   
  end


  def valid_cc_date
    return true if expiration_month.nil? or expiration_year.nil?
    if expiration_year < Date.today.year
      errors.add(:registration, "Not a valid expiration date")
      return false
    elsif expiration_month < Date.today.month and expiration_year <= Date.today.year
      errors.add(:registration, "Not a valid expiration date")
      return false
    end
    return true

  end


end 
