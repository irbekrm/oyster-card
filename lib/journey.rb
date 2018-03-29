class Journey
  
  MINIMUM_FARE = 1
  MINIMUM_PENALTY = 6
  
  attr_reader :paid

  def initialize(options={})
    @entry_station = options[:entry]
    @exit_station = options[:exit]
    @paid = false
  end

  
  def finish exit=nil
    @exit_station = @exit_station || exit
    fare
  end

  def complete?
    !(@entry_station.nil? || @exit_station.nil?)
  end

  private
  def fare
    @paid = true
    complete? ? MINIMUM_FARE : MINIMUM_PENALTY
  end
end
