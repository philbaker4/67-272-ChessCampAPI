require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  should belong_to(:camp)
  should belong_to(:student)
  
  

  should validate_presence_of(:camp_id)
  should validate_presence_of(:student_id)

  
  should allow_value(1).for(:camp_id)
  should_not allow_value(0).for(:camp_id)
  should_not allow_value("bad").for(:camp_id)
  should_not allow_value(nil).for(:camp_id)

  should allow_value(1).for(:student_id)
  should_not allow_value(0).for(:student_id)
  should_not allow_value("bad").for(:student_id)
  should_not allow_value(nil).for(:student_id)


  #validate base64 encode


  context "within context" do 
    setup do 
      create_users
      create_families
      create_students
      create_more_students
      create_locations
      create_curriculums
      create_more_curriculums
      create_camps
      create_upcoming_registrations

    end

      
    teardown do
      delete_upcoming_registrations
      delete_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations
      delete_more_students
      delete_students
      delete_families
      delete_users
    end

    should "get registrations in alphabetical order by student last name, first name" do
      assert_equal ["Five, Student", "Four, Student", "Four, Student"], Registration.alphabetical.map { |r| r.student.name  }
    end

    should "get all registrations for a camp" do 
      assert_equal ["Student Four"], Registration.for_camp(@camp1.id).all.map { |c| c.student.proper_name  }.sort
      assert_equal ["Student Four"], Registration.for_camp(@camp2.id).all.map { |c| c.student.proper_name  }.sort
      assert_equal ["Student Five"], Registration.for_camp(@camp4.id).all.map { |c| c.student.proper_name  }.sort
    end

    should "make sure that student is active in the system" do
      @appropCamp = FactoryBot.create(:camp, curriculum: @nimzo,start_date: Date.new(2018,7,24), end_date: Date.new(2018,7,27), location: @cmu  )
      assert @appropCamp.valid?

      @inactiveStud = FactoryBot.build(:registration, student: @studThree, camp: @appropCamp )
      deny @inactiveStud.valid?

      @activeStud = FactoryBot.build(:registration, student: @studTwo, camp: @camp4 )
      assert @activeStud.valid?
    end

    should "make sure that camp is active in the system" do

      @appropStudent = FactoryBot.create(:student, first_name: "Student", last_name: "Test", family: @famTwo, rating: 600, date_of_birth: 10.years.ago + 1.day)
      assert @appropStudent.valid?
      
      @inactiveCamp = FactoryBot.build(:registration, student: @appropStudent, camp: @camp3 )
      deny @inactiveCamp.valid?

      @activeCamp = FactoryBot.build(:registration, student: @appropStudent, camp: @camp2 )
      assert @activeCamp.valid?
    end

    should "make sure that student has appropriate rating" do 
      @appropStudent = FactoryBot.create(:student, first_name: "Student", last_name: "Test", family: @famTwo, rating: 600, date_of_birth: 10.years.ago + 1.day)
      assert @appropStudent.valid?
      
      @inRange = FactoryBot.build(:registration, student: @appropStudent, camp: @camp2 )
      assert @inRange.valid?

      @outOfRange = FactoryBot.build(:registration, student: @appropStudent, camp: @camp4 )
      deny @outOfRange.valid?
    end

    should "make sure that student is not registered for another camp on the same date" do

      @appropStudent = FactoryBot.create(:student, first_name: "Student", last_name: "Test", family: @famTwo, rating: 600, date_of_birth: 10.years.ago + 1.day)
      assert @appropStudent.valid?

      @sameDateCamp = FactoryBot.create(:camp, curriculum: @tactics,  location: @north)
      assert @sameDateCamp.valid?

      validRegist = FactoryBot.create(:registration, student: @appropStudent, camp: @camp1)
      invalidRegist = FactoryBot.build(:registration, student: @appropStudent, camp: @sameDateCamp)
      
      assert validRegist.valid?
      deny invalidRegist.valid?
    end

    should "has attribute accessors for credit card num, month, year" do 
      assert @upcRegOne.respond_to?("credit_card_number=")
      assert @upcRegOne.respond_to?("credit_card_number")
      assert @upcRegOne.respond_to?("expiration_year=")
      assert @upcRegOne.respond_to?("expiration_year")
      assert @upcRegOne.respond_to?("expiration_month=")
      assert @upcRegOne.respond_to?("expiration_month")
      @upcRegOne.credit_card_number = 4123456789012
      assert @upcRegOne.valid?
      @upcRegOne.expiration_month = 10
      assert @upcRegOne.valid?
      @upcRegOne.expiration_year = 2020
      assert @upcRegOne.valid?
    end

    should "validate credit card date" do
      @upcRegOne.expiration_month = 10
      assert @upcRegOne.valid?
      @upcRegOne.expiration_year = 2020
      assert @upcRegOne.valid?

      @upcRegOne.expiration_month = 11
      assert @upcRegOne.valid?
      @upcRegOne.expiration_year = 2018
      assert @upcRegOne.valid?

      @upcRegOne.expiration_month = 3
      deny @upcRegOne.valid?

      @upcRegOne.expiration_month = 11
      assert @upcRegOne.valid?
      @upcRegOne.expiration_year = 2018
      assert @upcRegOne.valid?


      @upcRegOne.expiration_year = 2016
      deny  @upcRegOne.valid?

    end

    should 'validate credit card number' do 
      assert @upcRegOne.valid?

      @upcRegOne.credit_card_number = 4123456789012
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 4123456789012345
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 5123456789012345
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 5412345678901234
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 6512345678901234
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 6011123456789012
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 30012345678901
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 30312345678901
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 341234567890123
      assert @upcRegOne.valid?
      @upcRegOne.credit_card_number = 371234567890123
      assert @upcRegOne.valid?
 
      @upcRegOne.credit_card_number = 412345678901
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 412345678901234
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 41234567890123456
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 51234567890123
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 54123456789012345
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 651234567890123
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 60111234567890123
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 3001234567890
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 303123456789012
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 34123456789012
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 3712345678901234
      deny @upcRegOne.valid?

      @upcRegOne.credit_card_number = 1123456789012345
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 5623456789012345
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 6612345678901234
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 6001123456789012
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 30612345678901
      deny @upcRegOne.valid?
      @upcRegOne.credit_card_number = 351234567890123
      deny @upcRegOne.valid?
    end

    should "have pay method to save payment receipt" do
      @upcRegOne.expiration_month = 10
      @upcRegOne.expiration_year = 2020
      @upcRegOne.credit_card_number = 4123456789012
      assert_nil @upcRegOne.payment
      assert_equal String, @upcRegOne.pay.class
      assert_not_nil @upcRegOne.payment
      deny @upcRegOne.pay

      @upcRegTwo.expiration_month = 10
      @upcRegTwo.expiration_year = 2010
      @upcRegTwo.credit_card_number = 4123456789012
      deny @upcRegTwo.pay
    end





  end

end
