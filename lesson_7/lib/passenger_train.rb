class PassengerTrain < Train
  def initialize(number)
    super(number)
  end

  def to_s
    "Поезд пассажирский номер: #{number} вагонов: #{wagons.size}"
  end
end
