# frozen_string_literal: true

module Validate
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected

  def validate!
    raise NotImplementedError
  end
end
