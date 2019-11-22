# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def to_s
    "Поезд пассажирский номер: #{number} вагонов: #{wagons.size}"
  end
end
