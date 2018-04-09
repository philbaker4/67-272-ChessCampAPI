module Contexts
  module RegistrationContexts
    def create_past_registrations
      @pastRegOne = FactoryBot.create(:registration, camp: @camp10, student: @studOne)
      @pastRegTwo = FactoryBot.create(:registration, camp: @camp11, student: @studTwo)
      @pastRegThree = FactoryBot.create(:registration, camp: @camp12, student: @studTwo)
    end

    def delete_past_registrations
      @pastRegOne.delete
      @pastRegTwo.delete
      @pastRegThree.delete
    end

    def create_upcoming_registrations
      @upcRegOne = FactoryBot.create(:registration, camp: @camp1, student: @studFour)
      @upcRegTwo = FactoryBot.create(:registration, camp: @camp2, student: @studFour)
      @upcRegThree = FactoryBot.create(:registration, camp: @camp4, student: @studFive)
    end

    def delete_upcoming_registrations
      @upcRegOne.delete
      @upcRegTwo.delete
      @upcRegThree.delete
    end

   
  end
end