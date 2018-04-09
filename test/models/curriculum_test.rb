require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:camps)

  # test validations
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive

  should allow_value(1000).for(:min_rating)
  should allow_value(100).for(:min_rating)
  should allow_value(2872).for(:min_rating)
  should allow_value(0).for(:min_rating)

  should_not allow_value(nil).for(:min_rating)
  should_not allow_value(3001).for(:min_rating)
  should_not allow_value(50).for(:min_rating)
  should_not allow_value(-1).for(:min_rating)
  should_not allow_value(500.50).for(:min_rating)
  should_not allow_value("bad").for(:min_rating)

  should allow_value(1000).for(:max_rating)
  should allow_value(100).for(:max_rating)
  should allow_value(2872).for(:max_rating)

  should_not allow_value(nil).for(:max_rating)
  should_not allow_value(3001).for(:max_rating)
  should_not allow_value(50).for(:max_rating)
  should_not allow_value(-1).for(:max_rating)
  should_not allow_value(500.50).for(:max_rating)
  should_not allow_value("bad").for(:max_rating)

    # test that max greater than min rating
  should "shows that max rating is greater than min rating" do
    bad = FactoryBot.build(:curriculum, name: "Bad curriculum", min_rating: 500, max_rating: 500)
    very_bad = FactoryBot.build(:curriculum, name: "Very bad curriculum", min_rating: 500, max_rating: 450)
    deny bad.valid?
    deny very_bad.valid?
  end

  context "Within context" do
    # create the objects I want with factories
    setup do 
      create_curriculums
    end
    
    # and provide a teardown method as well
    teardown do
      delete_curriculums
    end

    # test the scope 'alphabetical'
    should "shows that there are three curriculums in in alphabetical order" do
      assert_equal ["Endgame Principles", "Mastering Chess Tactics", "Smith-Morra Gambit"], Curriculum.alphabetical.all.map(&:name), "#{Curriculum.class}"
    end
    
    # test the scope 'active'
    should "shows that there are two active curriculums" do
      assert_equal 2, Curriculum.active.size
      assert_equal ["Endgame Principles", "Mastering Chess Tactics"], Curriculum.active.all.map(&:name).sort, "#{Curriculum.methods}"
    end
    
    # test the scope 'active'
    should "shows that there is one inactive curriculum" do
      assert_equal 1, Curriculum.inactive.size
      assert_equal ["Smith-Morra Gambit"], Curriculum.inactive.all.map(&:name).sort
    end

    # test the scope 'for_rating'
    should "shows that there is a working for_rating scope" do
      assert_equal 1, Curriculum.for_rating(1400).size
      assert_equal ["Mastering Chess Tactics","Smith-Morra Gambit"], Curriculum.for_rating(600).all.map(&:name).sort
    end

    should "never be destroyed" do 
      assert_equal 3, Curriculum.all.size
      @tactics.destroy
      assert_equal 3, Curriculum.all.size
    end

    should "not be made inactive unless there are no upcoming camps with the curriculum that have any registrations" do

      create_users
      create_locations
      create_camps
      create_families
      create_more_students
      create_upcoming_registrations

      @smithmorra.update_attribute(:active, true)
      assert @smithmorra.active
      @smithmorra.destroy
      deny @smithmorra.active
      
      assert @tactics.active
      @tactics.destroy
      assert @tactics.active


      delete_upcoming_registrations
      delete_more_students
      delete_families
      delete_camps
      delete_locations
      delete_users
    end



  end
end
