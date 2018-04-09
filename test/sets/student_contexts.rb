module Contexts
  module StudentContexts
    def create_students
      @studOne    = FactoryBot.create(:student, family: @famOne)
      @studTwo   = FactoryBot.create(:student, first_name: "Student", last_name: "Two", family: @famTwo, rating: 1000, date_of_birth: 10.years.ago + 1.day)
      @studThree = FactoryBot.create(:student, first_name: "Student", last_name: "Three", family: @famTwo, rating: 1800, active: false, date_of_birth: 10.years.ago )
    end

    def delete_students
      @studOne.delete
      @studTwo.delete
      @studThree.delete
    end

    def create_more_students
      @studFour = FactoryBot.create(:student, first_name: "Student", last_name: "Four", family: @famTwo, rating: 500,  date_of_birth: 10.years.ago )
      @studFive = FactoryBot.create(:student, first_name: "Student", last_name: "Five", family: @famTwo, rating: 800,  date_of_birth: 10.years.ago )
    end

    def delete_more_students
      @studFour.delete
      @studFive.delete
    end

     
  end
end 