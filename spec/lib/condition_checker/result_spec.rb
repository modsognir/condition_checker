require 'spec_helper'

RSpec.describe ConditionChecker::Result do
  describe '#initialize' do
    it 'converts name to string' do
      result = described_class.new(name: :test, value: true)
      expect(result.name).to eq('test')
    end

    it 'sets the value' do
      result = described_class.new(name: 'test', value: true)
      expect(result.value).to be true
    end
  end

  describe '#success?' do
    it 'returns true when value is true' do
      result = described_class.new(name: 'test', value: true)
      expect(result).to be_success
    end

    it 'returns true when value is truthy' do
      result = described_class.new(name: 'test', value: 'some value')
      expect(result).to be_success
    end

    it 'returns false when value is false' do
      result = described_class.new(name: 'test', value: false)
      expect(result).not_to be_success
    end

    it 'returns false when value is nil' do
      result = described_class.new(name: 'test', value: nil)
      expect(result).not_to be_success
    end
  end

  describe '#fail?' do
    it 'returns true when value is false' do
      result = described_class.new(name: 'test', value: false)
      expect(result).to be_fail
    end

    it 'returns false when value is true' do
      result = described_class.new(name: 'test', value: true)
      expect(result).not_to be_fail
    end

    it 'returns false when value is truthy' do
      result = described_class.new(name: 'test', value: 'some value')
      expect(result).not_to be_fail
    end

    it 'returns false when value is nil' do
      result = described_class.new(name: 'test', value: nil)
      expect(result).not_to be_fail
    end
  end

  describe '#==' do
    it 'returns true when name and value match' do
      result1 = described_class.new(name: 'test', value: true)
      result2 = described_class.new(name: 'test', value: true)
      expect(result1).to eq(result2)
    end

    it 'returns false when names differ' do
      result1 = described_class.new(name: 'test1', value: true)
      result2 = described_class.new(name: 'test2', value: true)
      expect(result1).not_to eq(result2)
    end

    it 'returns false when values differ' do
      result1 = described_class.new(name: 'test', value: true)
      result2 = described_class.new(name: 'test', value: false)
      expect(result1).not_to eq(result2)
    end
  end
end 
