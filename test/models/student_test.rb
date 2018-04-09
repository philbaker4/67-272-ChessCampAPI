require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  should belong_to(:family)
  should have_many(:registrations)
  should have_many(:camps).through(:registrations)

  # test validations
  should validate_presence_of(:family_id)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)


  should allow_value(0).for(:rating)
  should allow_value(nil).for(:rating)
  should allow_value(100).for(:rating)
  should allow_value(3000).for(:rating)
  should_not allow_value(-1).for(:rating)
  should_not allow_value(1).for(:rating)
  should_not allow_value(99).for(:rating)
  should_not allow_value(3001).for(:rating)
  should_not allow_value("bad").for(:rating)
  should_not allow_value(100.100).for(:rating)


  should allow_value(Date.today).for(:date_of_birth)
  should allow_value(Date.today - 10 ).for(:date_of_birth)
  should allow_value(nil).for(:date_of_birth)
  should_not allow_value(Date.today + 1 ).for(:date_of_birth)


  should allow_value(1).for(:family_id)
  should_not allow_value(0).for(:family_id)
  should_not allow_value("bad").for(:family_id)
  should_not allow_value(nil).for(:family_id)

  
  # set up context
  context "Within context" do
    setup do 
      create_users
      create_families
      create_students

    end
    
    teardown do
      delete_students
      delete_families
      delete_users

    end

    should "show that there are three locations in in alphabetical order" do
      assert_equal ["One", "Three", "Two"], Student.alphabetical.map{|student| student.last_name}
    end

    should "show that there are two active students " do
      assert_equal ['One', 'Two'], Student.active.map { |student| student.last_name  }.sort
    end

    should "show that there is one inactive student " do
      assert_equal ['Three'], Student.inactive.map { |student| student.last_name  }.sort
    end

    should "show that there are two students with a rating below 1799 " do
      assert_equal ['One','Two'], Student.below_rating(1799).map { |student| student.last_name  }.sort
    end

    should "show that there are two students with a rating above or equal to 100 " do
      assert_equal ['Three','Two'], Student.at_or_above_rating(100).map { |student| student.last_name  }.sort
    end

    should "show get name " do
      assert_equal 'Two, Student', @studTwo.name
    end

    should "show get proper name " do
      assert_equal 'Student Two', @studTwo.proper_name
    end

    should "show get age " do
      assert_equal 9, @studTwo.age
      assert_equal 10, @studThree.age
    end

    should "set rating to 0 if left blank" do
      @studFour  = FactoryBot.create(:student, first_name: "Student", last_name: "Four", family: @famTwo, rating: nil)
      assert_equal 0, @studFour.rating
      @studFour.delete

    end

    should "only delete students with no past registrations. make others inactive" do
      create_locations
      create_curriculums
      create_more_curriculums
      create_past_camps
      create_past_registrations

      assert_equal 3, Student.all.size
      @studOne.destroy
      deny @studOne.active
      assert_equal 3, Student.all.size
      
      @studTwo.destroy
      assert_equal 3, Student.all.size
      deny @studTwo.active

      @studThree.destroy
      assert_equal 2, Student.all.size

      @studThree = FactoryBot.create(:student, first_name: "Student", last_name: "Three", family: @famTwo, rating: 1800, active: false, date_of_birth: 10.years.ago )
      # so that delete_students doesnt throw an error


      delete_past_registrations
      delete_past_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations

    end

    should "on delete: remove upcoming registrations before a student is deleted" do
      create_locations
      create_curriculums
      create_more_curriculums
      create_camps
      create_more_students
      create_upcoming_registrations

      assert_equal 2, Registration.where("student_id = ? ", @studFour.id).size
      assert_equal 1, Registration.where("student_id = ? ", @studFive.id).size

      @studFour.destroy

      assert_equal 0, Registration.where("student_id = ? ", @studFour.id).size
      assert_equal 1, Registration.where("student_id = ? ", @studFive.id).size

      @studFive.delete

      delete_upcoming_registrations
      delete_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations

    end

    should "remove upcoming registrations if a student is made inactive" do
      create_locations
      create_curriculums
      create_more_curriculums
      create_camps

      @studFour = FactoryBot.create(:student, first_name: "Student", last_name: "Four", family: @famTwo, rating: 500,  date_of_birth: 10.years.ago )
      @studFive = FactoryBot.create(:student, first_name: "Student", last_name: "Five", family: @famTwo, rating: 800,  date_of_birth: 10.years.ago )

      create_upcoming_registrations

      assert_equal 2, Registration.where("student_id = ? ", @studFour.id).size
      assert_equal 1, Registration.where("student_id = ? ", @studFive.id).size

      @studFour.update_attribute(:active, false)

      assert_equal 0, Registration.where("student_id = ? ", @studFour.id).size
      assert_equal 1, Registration.where("student_id = ? ", @studFive.id).size

      
      delete_upcoming_registrations
      delete_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations

    end




  end
end

















