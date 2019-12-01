# frozen_string_literal: true

class CargoTrain < Train
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :cargo)
  end

  def to_s
    "Поезд грузовой номер: #{number} вагонов: #{wagons.size}"
  end
end
