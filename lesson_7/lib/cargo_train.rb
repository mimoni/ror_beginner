# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def to_s
    "Поезд грузовой номер: #{number} вагонов: #{wagons.size}"
  end
end
