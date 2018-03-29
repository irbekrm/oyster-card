require 'oystercard'

describe Oystercard do
  subject(:a_oystercard) { described_class.new }
  subject(:b_oystercard) { described_class.new(5.00) }
  
  before(:each) do
    @station = double(:station)
  end

  it 'Should create an instance (passed no arguments) with a default balance of 0' do
    expect(a_oystercard.balance).to eq 0.00
  end

  it 'Should create an instance (passed starting balance of 5.00) with 5.00 balance' do
    expect(b_oystercard.balance).to eq 5.00
  end
  
  it 'Should be initialized with no history' do
    expect(subject.history).to be_empty
  end

  describe '#top-up' do

    it 'Should allow the user to top up the value on the oyster card by £5' do
      a_oystercard.top_up(5.00)
      expect(a_oystercard.balance).to eq 5.00
    end

    it 'Should not allow the user to top up the value past the maximum of £90' do
      a_oystercard.top_up(70)
      expect { a_oystercard.top_up(21) }.to raise_error 'Over maximum balance'
    end
  end

  describe '#deduct' do
  
     it 'Should deduct the fare from the balance' do
       a_oystercard.top_up(80)
       expect{a_oystercard.send(:deduct, 3)}.to change{a_oystercard.balance}.by -3
     end
  
   end

  describe '#touch_in' do
    it 'Should raise an error when user touch in with balance less than minimum amount' do
      expect { a_oystercard.touch_in(@station) }.to raise_error 'Insufficient funds'
    end
  end

  describe '#touch_out' do

    it 'Should deduct the fare when touch out (completed journey)' do
      b_oystercard.touch_in(@station)
      expect { b_oystercard.touch_out @station }.to change { b_oystercard.balance }.by -Journey::MINIMUM_FARE
    end
  end

  describe '#in_journey?' do

    it 'Initially should not in journey' do
      expect(b_oystercard.in_journey?).to be false
    end

    it 'Should be in journey after touch in' do
      b_oystercard.touch_in(@station)
      expect(b_oystercard.in_journey?).to be true
    end

    it 'Should not be in journey after touch out' do
      b_oystercard.touch_in(@station)
      b_oystercard.touch_out @station
      expect(b_oystercard.in_journey?).to be false
    end
  end

end
