require 'spec_helper'

RSpec.describe ConditionChecker::Condition do
  let(:name) { 'is_valid' }
  let(:conditional) { ->(obj) { obj.is_a?(String) } }
  let(:condition) { described_class.new(name, conditional) }

  describe '#initialize' do
    it 'sets the name and conditional' do
      expect(condition.name).to eq('is_valid')
      expect(condition.conditional).to be_a(Proc)
    end

    it 'converts symbol names to strings' do
      condition = described_class.new(:is_valid, conditional)
      expect(condition.name).to eq('is_valid')
    end

    it 'initializes with a nil result' do
      expect(condition.value).to be_nil
    end
  end

  describe '#call' do
    it 'returns a Result object' do
      result = condition.call('test')
      expect(result).to be_a(ConditionChecker::Result)
    end

    it 'sets the result internally' do
      condition.call('test')
      expect(condition.result).to be_a(ConditionChecker::Result)
    end

    it 'evaluates the conditional with the given object' do
      result = condition.call('test')
      expect(result.value).to be true

      result = condition.call(123)
      expect(result.value).to be false
    end

    it 'includes the condition name in the result' do
      result = condition.call('test')
      expect(result.name).to eq('is_valid')
    end
  end

  describe '#success?' do
    context 'when condition has not been called' do
      it 'returns false' do
        expect(condition.success?).to be false
      end
    end

    context 'when condition was successful' do
      before { condition.call('test') }

      it 'returns true' do
        expect(condition.success?).to be true
      end
    end

    context 'when condition failed' do
      before { condition.call(123) }

      it 'returns false' do
        expect(condition.success?).to be false
      end
    end
  end

  describe '#fail?' do
    context 'when condition has not been called' do
      it 'returns true' do
        expect(condition.fail?).to be true
      end
    end

    context 'when condition was successful' do
      before { condition.call('test') }

      it 'returns false' do
        expect(condition.fail?).to be false
      end
    end

    context 'when condition failed' do
      before { condition.call(123) }

      it 'returns true' do
        expect(condition.fail?).to be true
      end
    end
  end
end 
