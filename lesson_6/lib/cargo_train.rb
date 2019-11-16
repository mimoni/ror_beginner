class CargoTrain < Train
  def initialize(number)
    super(number)
  end

  def info
    "Грузовой поезд номер:#{number}"
  end
end
