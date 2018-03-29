require 'journey'

describe Journey do
  subject { described_class.new }

  before(:each) do
    @station1 = double("station1")
    @station2 = double("station2")
    @completed_journey = described_class.new(:entry => @station1, :exit => @station2)
  end

  describe '#complete?' do
    it 'returns true if journey has entry and exit stations' do
      expect(@completed_journey.complete?).to eq true
    end

    it 'returns false if entry station is missing' do
      expect((described_class.new(:exit => @station2)).complete?).to eq false
    end

    it 'it returns false if exit station is missing' do
      expect((described_class.new(:entry => @station1)).complete?).to eq false
    end
  end

  describe '#finish' do
    it "returns #{Journey::MINIMUM_FARE} if the journey is complete" do
      expect(@completed_journey.finish).to eq Journey::MINIMUM_FARE
    end

    it "returns #{Journey::MINIMUM_PENALTY} if the journey is not complete" do
      expect((described_class.new(:entry => @station2)).finish).to eq Journey::MINIMUM_PENALTY
    end
  end

  describe '#paid' do
    it 'returns true if the journey has been finished' do
      subject.finish
      expect(subject.paid).to be true
    end

    it 'returns false if the journey has not been finished' do
      expect(subject.paid).to be false
    end
  end
end
