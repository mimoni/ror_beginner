class CargoWagon < Wagon
  attr_reader :taken_space

  def initialize(volume = 100)
    @volume = volume
    @taken_space = 0
    super(CargoTrain)
  end

  def load(volume)
    @taken_space = [@taken_space + volume, @volume].min
  end

  def available_volume
    @volume - @taken_space
  end

  def to_s
    "номер вагона:#{@name} тип: грузовой, кол-во свободного объема: #{available_volume} занятого объема: #{@taken_space}"
  end

  protected

  def validate!
    raise 'Объем грузового вагона может быть в пределах от 50 до 300 ' unless @volume.between?(50, 300)
  end
end
