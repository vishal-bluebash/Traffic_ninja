# frozen_string_literal: true

class PingValidatorService
  include ActiveModel::Validations

  attr_reader :type, :app_id

  ALLOWED_TYPE = %w[dynamic lite static].freeze
  validates :app_id, presence: true, numericality: true
  validates :type, presence: true, inclusion: { in: ALLOWED_TYPE }

  def initialize(type = nil, app_id = nil)
    @type = type
    @app_id = app_id
  end
end
