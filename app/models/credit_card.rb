







class CreditCard
    @@amex = CreditCardType.new('AMEX','^(34|37)\d{13}$' )
    @@dccb = CreditCardType.new('DCCB','^30[0-5]{1}\d{11}$' )
    @@disc = CreditCardType.new('DISC', '^(6011\d{12})$|^(65\d{14})$' )
    @@mc = CreditCardType.new('MC','^5[1-5]\d{14}$' )
    @@visa = CreditCardType.new('VISA', '^4\d{15}$|^4\d{12}$')
    @@cards = [@@amex, @@dccb, @@disc, @@mc, @@visa]
  
  attr_reader :number, :year, :month, :type
  def initialize(n, y, m)
    @number, @year, @month = n,y,m

    @@cards.each do |ct|
      if ct.match(number)
        @type = ct
      end
    end
  end


  def valid?
    if type.nil?
      return false
    end
    if year < Date.today.year
      return false
    elsif month < Date.today.month and year <= Date.today.year
      return false
    end
    return true

  end



end







