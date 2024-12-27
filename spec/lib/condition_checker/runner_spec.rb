require 'spec_helper'

RSpec.describe ConditionChecker::Runner do
  # Test class that mimics the README example
  class TestHealth
    include ConditionChecker::Mixin

    def value_check
      context.value > 15
    end

    def under_thirty
      context.value < 30
    end

    condition "increment", ->(obj) { obj.value += 1; true }
    condition "double", ->(obj) { obj.value *= 2; true }

    check :value_above_15, conditions: ["increment", "double", "value_check"]
    check "value_below_30", conditions: ["increment", "double", "under_thirty"]
  end

  let(:test_object) { OpenStruct.new(value: 10) }
  let(:test_health) { TestHealth }
  
  subject(:runner) { test_health.for(test_object) }

  describe '#initialize' do
    it 'sets up the runner with the test object' do
      expect(runner.object).to eq(test_object)
    end
  end

  describe '#run' do
    it 'executes conditions and returns self' do
      expect(runner.run).to eq(runner)
      # After conditions run: 10 -> 11 -> 22
      expect(test_object.value).to eq(22)
    end
  end

  describe '#[]' do
    before { runner.run }

    it 'finds a check by name' do
      expect(runner["value_above_15"]).to be_success
      expect(runner[:value_above_15]).to be_success
      expect(runner["value_below_30"]).to be_success
    end

    it 'returns nil for unknown check names' do
      expect(runner["unknown"]).to be_nil
    end
  end

  describe '#check' do
    it 'is an alias for []' do
      runner.run
      expect(runner.check("value_above_15")).to eq(runner["value_above_15"])
    end
  end

  describe '#checks' do
    it 'returns all checks' do
      expect(runner.checks.size).to eq(2)
      expect(runner.checks.map(&:name)).to contain_exactly(
        "value_above_15",
        "value_below_30"
      )
    end

    it 'runs checks if not already run' do
      expect(runner).to receive(:run).and_call_original
      runner.checks
    end

    context 'when already run' do
      before { runner.run }

      it 'returns checks without running again' do
        expect(runner).not_to receive(:run)
        runner.checks
      end
    end
  end

  describe '#successes' do
    before { runner.run }

    it 'returns successful checks' do
      expect(runner.successes.map(&:name)).to contain_exactly(
        "value_above_15",
        "value_below_30"
      )
    end

    context 'with failing checks' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'returns only successful checks' do
        expect(runner.successes.map(&:name)).to contain_exactly("value_below_30")
      end
    end
  end

  describe '#fails' do
    before { runner.run }

    it 'returns no failing checks when all succeed' do
      expect(runner.fails).to be_empty
    end

    context 'with failing checks' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'returns failing checks' do
        expect(runner.fails.map(&:name)).to contain_exactly("value_above_15")
      end
    end
  end

  describe '#success?' do
    before { runner.run }

    it 'returns true when all checks pass' do
      expect(runner.success?).to be true
    end

    context 'with failing checks' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'returns false' do
        expect(runner.success?).to be false
      end
    end
  end

  describe '#fail?' do
    before { runner.run }

    it 'returns false when all checks pass' do
      expect(runner.fail?).to be false
    end

    context 'with failing checks' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'returns true' do
        expect(runner.fail?).to be true
      end
    end
  end

  describe 'integration with conditions and checks' do
    before { runner.run }

    it 'allows accessing condition results through checks' do
      check = runner["value_above_15"]
      expect(check.conditions.map(&:name)).to eq(["increment", "double", "value_check"])
      expect(check.conditions.map(&:success?)).to all(be true)
    end

    context 'with failing conditions' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'tracks failed conditions' do
        check = runner["value_above_15"]
        expect(check.conditions.map(&:success?)).to eq([true, true, false])
      end
    end
  end
end 
