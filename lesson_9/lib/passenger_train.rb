# frozen_string_literal: true

class PassengerTrain < Train
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :passenger)
  end

  def to_s
    "Поезд пассажирский номер: #{number} вагонов: #{wagons.size}"
  end
end
