require 'spec_helper'

RSpec.describe ConditionChecker::Check do
  class TestCondition
    def initialize(result)
      @result = result
    end

    def call(context)
      ConditionChecker::Result.new(name: "test_check", value: @result)
    end
  end

  let(:name) { "test_check" }
  let(:test_context) { "test" } 
  let(:passing_condition) { TestCondition.new(true) }
  let(:failing_condition) { TestCondition.new(false) }
  
  describe '#initialize' do
    let(:check) { described_class.new(name, [passing_condition]) }

    it 'sets the name and conditions' do
      expect(check.name).to eq("test_check")
      expect(check.conditions).to eq([passing_condition])
      expect(check.result).to be_nil
    end

    it 'converts name to string' do
      check = described_class.new(:symbol_name, [passing_condition])
      expect(check.name).to eq("symbol_name")
    end
  end

  describe '#call' do
    let(:check) { described_class.new(name, [passing_condition, failing_condition]) }

    it 'returns an array of results' do
      results = check.call(test_context)
      expect(results.size).to eq(2)
      expect(results.first.value).to be true
      expect(results.last.value).to be false
    end

    it 'stores the results' do
      check.call(test_context)
      expect(check.result.size).to eq(2)
      expect(check.result.first.value).to be true
      expect(check.result.last.value).to be false
    end
  end

  describe '#successes' do
    let(:check) { described_class.new(name, [passing_condition, failing_condition]) }

    it 'returns successful results' do
      check.call(test_context)
      expect(check.successes.size).to eq(1)
      expect(check.successes.first.value).to be true
    end
  end

  describe '#fails' do
    let(:check) { described_class.new(name, [passing_condition, failing_condition]) }

    it 'returns failed results' do
      check.call(test_context)
      expect(check.fails.size).to eq(1)
      expect(check.fails.first.value).to be false
    end
  end

  describe '#success?' do
    before { check.call(test_context) }

    context 'when all conditions pass' do
      let(:check) { described_class.new(name, [passing_condition, passing_condition]) }

      it 'returns true' do
        expect(check).to be_success
      end
    end

    context 'when any condition fails' do
      let(:check) { described_class.new(name, [passing_condition, failing_condition]) }

      it 'returns false' do
        expect(check).to_not be_success
      end
    end
  end

  describe '#fail?' do
    before { check.call(test_context) }
    context 'when all conditions pass' do
      let(:check) { described_class.new(name, [passing_condition, passing_condition]) }

      it 'returns false' do
        expect(check).to_not be_fail
      end
    end

    context 'when any condition fails' do
      let(:check) { described_class.new(name, [passing_condition, failing_condition]) }

      it 'returns true' do
        expect(check).to be_fail
      end
    end
  end
end 
