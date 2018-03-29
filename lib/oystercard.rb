class Oystercard
  attr_reader :balance, :entry_station, :history

  DEFAULT_BALANCE = 0.00
  MAXIMUM_BALANCE = 90.00
  MINIMUM_AMOUNT = 1.00
  CHARGE = 2.40

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @in_journey = false
    @history = []
  end

  def top_up(amount)
    max_balance_error = 'Cannot top up past maximum value of £90'
    raise max_balance_error if (@balance + amount) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    deduct(@history.last.finish) unless (@history.last.nil? || @history.last.paid)
    minimum_amount_error = 'The minimum amount for a single journey is £1'
    raise minimum_amount_error if less_minimum?
    make_journey(entry: station)
  end

  def touch_out station
    !@history.last || @history.last.paid ?  deduct(make_journey(exit: station).finish) : deduct(@history.last.finish station)
  end

  def in_journey?
    !(@history.last.nil? || @history.last.paid)
  end

  private
  def make_journey(options={})
    @history << Journey.new(entry: options[:entry], exit: options[:exit])
    @history.last
  end

  def deduct(fare)
    @balance -= fare
  end

  def less_minimum?
    @balance < MINIMUM_AMOUNT
  end
end

