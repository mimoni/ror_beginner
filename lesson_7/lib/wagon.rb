class Wagon
  include Validate
  include Manufacturer
  include InstanceCounter
  attr_reader :type, :name

  def initialize(type)
    register_instance
    @type = type
    @name = self.class.instances
    validate!
  end

  protected

  def validate!
    raise 'Неправильно указан тип' unless @type == CargoTrain || @type == PassengerTrain
  end
end
