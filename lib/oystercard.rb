class Oystercard
  attr_reader :balance, :history

  DEFAULT_BALANCE = 0.00
  MAXIMUM_BALANCE = 90.00
  MINIMUM_AMOUNT = 1.00
  ERRORS = {:insufficient_funds => "Insufficient funds", :max_reached => "Over maximum balance"}

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @history = []
  end

  def top_up amount
    raise ERRORS[:max_reached] if (@balance + amount) > MAXIMUM_BALANCE
    @balance += amount
    self
  end

  def touch_in station
    deduct(previous.finish) unless (previous.nil? || previous.paid)
    raise ERRORS[:insufficient_funds] if under_minimum?
    make_journey(entry: station)
    self
  end

  def touch_out station
    !previous || previous.paid ?  deduct(make_journey(exit: station).finish) : deduct(previous.finish station)
    self
  end

  def in_journey?
    !(previous.nil? || previous.paid)
  end

  private
  def make_journey(options={})
    @history << Journey.new(options)
    previous
  end

  def deduct(fare)
    @balance -= fare
  end

  def under_minimum?
    @balance < MINIMUM_AMOUNT
  end
  
  def previous
    @history.last
  end
end

