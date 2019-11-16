class Wagon
  include Validate
  include Manufacturer
  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  protected

  def validate!
    raise 'Неправильно указан тип' unless @type == CargoTrain || @type == PassengerTrain
  end
end
