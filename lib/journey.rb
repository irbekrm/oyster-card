class Journey
  
  MINIMUM_FARE = 1
  MINIMUM_PENALTY = 6
  
  attr_reader :paid

  def initialize(options={})
    @entry_station = options[:entry]
    @exit_station = options[:exit]
    @paid = false
  end

  def fare
    @paid = true
    complete? ? MINIMUM_FARE : MINIMUM_PENALTY
  end
  
  def finish exit=nil
    @exit_station = exit
    fare
  end

  def complete?
    @entry_station && @exit_station
  end
end
