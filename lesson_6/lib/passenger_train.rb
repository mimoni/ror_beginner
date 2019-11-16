class PassengerTrain < Train
  def initialize(number)
    super(number)
  end

  def info
    "Пассажирский поезд номер:#{number}"
  end
end
