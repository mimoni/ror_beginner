class CargoTrain < Train
  def initialize(number)
    super(number)
  end

  def to_s
    "Поезд грузовой номер: #{number} вагонов: #{wagons.size}"
  end
end
