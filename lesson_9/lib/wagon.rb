# frozen_string_literal: true

class Wagon
  include Validate
  include Manufacturer
  include InstanceCounter
  attr_reader :type, :name

  validate :type, :presence
  validate :type, :custom, lambda { |type|
    types = %i[cargo passenger]
    raise 'Неправильно указан тип' unless types.include? type
  }

  def initialize(type, whole_space)
    register_instance
    @type = type
    @taken_space = 0
    @whole_space = whole_space
    @name = self.class.instances
    validate!
  end

  def take_space(volume = 1)
    @taken_space += volume if @taken_space < @whole_space
  end

  def available_space
    @whole_space - @taken_space
  end
end
