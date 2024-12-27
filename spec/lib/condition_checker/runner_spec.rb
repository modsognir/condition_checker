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

    condition "first_check", ->(obj) { true }
    condition "second_check", ->(obj) { true }

    check :value_above_15, conditions: ["first_check", "second_check", "value_check"]
    check "value_below_30", conditions: ["first_check", "second_check", "under_thirty"]
  end

  let(:test_object) { OpenStruct.new(value: 10) }
  let(:test_health) { TestHealth }
  
  subject(:runner) { test_health.for(test_object) }

  describe '#initialize' do
    it 'sets up the runner with the test object' do
      expect(runner.object).to eq(test_object)
    end
  end

  describe '#[]' do
    before { runner.run }

    it 'finds a check by name' do
      check = runner["value_above_15"]
      expect(check).to be_an_instance_of(ConditionChecker::Check)
      expect(check.name).to eq("value_above_15")

      check = runner[:value_above_15] 
      expect(check).to be_an_instance_of(ConditionChecker::Check)
      expect(check.name).to eq("value_above_15")

      check = runner["value_below_30"]
      expect(check).to be_an_instance_of(ConditionChecker::Check) 
      expect(check.name).to eq("value_below_30")
    end

    it 'returns nil for unknown check names' do
      expect(runner["unknown"]).to be_nil
    end
  end

  describe '#find' do
    it 'is an alias for []' do
      runner.run
      expect(runner.find("value_above_15")).to eq(runner["value_above_15"])
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

  describe 'integration with conditions and checks' do
    before { runner.run }

    context 'with successful conditions' do 
      let(:test_object) { OpenStruct.new(value: 20) }
      it 'allows accessing condition results through checks' do
        check = runner["value_above_15"]
        expect(check.conditions.map(&:name)).to eq(["first_check", "second_check", "value_check"])
        expect(check.successes.map(&:name)).to eq(["first_check", "second_check", "value_check"])
        expect(check.conditions.map(&:success?)).to all(be true)
        expect(check).to be_success
      end
    end

    context 'with failing conditions' do
      let(:test_object) { OpenStruct.new(value: 5) }

      it 'tracks failed conditions' do
        check = runner["value_above_15"]
        expect(check.conditions.map(&:success?)).to eq([true, true, false])
        expect(check.fails.map(&:name)).to eq(["value_check"])
      end
    end
  end
end 
