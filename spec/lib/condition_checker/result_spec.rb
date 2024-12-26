require 'spec_helper'

RSpec.describe ConditionChecker::Result do
  describe '#initialize' do
    it 'converts name to string' do
      result = described_class.new(name: :test, result: true)
      expect(result.name).to eq('test')
    end

    it 'stores the result value' do
      result = described_class.new(name: 'test', result: true)
      expect(result.result).to be true
    end
  end

  describe '#success?' do
    it 'returns true when result is true' do
      result = described_class.new(name: 'test', result: true)
      expect(result).to be_success
    end

    it 'returns true when result is truthy' do
      result = described_class.new(name: 'test', result: 'truthy value')
      expect(result).to be_success
    end

    it 'returns false when result is false' do
      result = described_class.new(name: 'test', result: false)
      expect(result).not_to be_success
    end

    it 'returns false when result is nil' do
      result = described_class.new(name: 'test', result: nil)
      expect(result).not_to be_success
    end
  end

  describe '#fail?' do
    it 'returns true when result is false' do
      result = described_class.new(name: 'test', result: false)
      expect(result).to be_fail
    end

    it 'returns false when result is true' do
      result = described_class.new(name: 'test', result: true)
      expect(result).not_to be_fail
    end

    it 'returns false when result is nil' do
      result = described_class.new(name: 'test', result: nil)
      expect(result).not_to be_fail
    end
  end

  describe '#==' do
    it 'returns true when name and result match' do
      result1 = described_class.new(name: 'test', result: true)
      result2 = described_class.new(name: 'test', result: true)
      expect(result1).to eq(result2)
    end

    it 'returns false when names differ' do
      result1 = described_class.new(name: 'test1', result: true)
      result2 = described_class.new(name: 'test2', result: true)
      expect(result1).not_to eq(result2)
    end

    it 'returns false when results differ' do
      result1 = described_class.new(name: 'test', result: true)
      result2 = described_class.new(name: 'test', result: false)
      expect(result1).not_to eq(result2)
    end

    it 'handles symbol names' do
      result1 = described_class.new(name: :test, result: true)
      result2 = described_class.new(name: 'test', result: true)
      expect(result1).to eq(result2)
    end
  end
end 
