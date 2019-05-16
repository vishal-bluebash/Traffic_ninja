# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingValidatorService do
  context 'with correct parameters' do
    it 'should be validate successfully' do
      validator = PingValidatorService.new('static', '234234')
      expect(validator.validate).to eq(true)
    end
  end

  context 'with un-permitted parameters' do
    it 'should validate app_id against alphanumeric' do
      validator = PingValidatorService.new('static', 'A234234')
      validator.validate
      expect(validator.errors.messages[:app_id]).to eq(['is not a number'])
    end

    it 'should validate type against whitelisted types' do
      validator = PingValidatorService.new('static1', '234234')
      validator.validate
      expect(validator.errors.messages[:type]).to eq(['is not included in the list'])
    end

    it 'should validate presence of type and app_id' do
      validator = PingValidatorService.new
      validator.validate
      expect(validator.errors.messages[:app_id]).to eq(["can't be blank", 'is not a number'])
      expect(validator.errors.messages[:type]).to eq(["can't be blank", 'is not included in the list'])
    end
  end
end
