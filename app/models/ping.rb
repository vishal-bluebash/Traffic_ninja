# frozen_string_literal: true

class Ping < ApplicationRecord
  after_validation :save_validation_errors

  def save_validation_errors
    ping_validator = PingValidatorService.new(parameters['type'], parameters['app_id'])
    unless ping_validator.validate
      self.validation_errors = ping_validator.errors.messages
    end
  end
end
