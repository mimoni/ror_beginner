class CargoWagon < Wagon
  def initialize(volume = 100)
    super(:cargo, volume)
  end

  def to_s
    "номер вагона:#{@name} тип: грузовой, кол-во свободного объема: #{available_space} занятого объема: #{@taken_space}"
  end

  protected

  def validate!
    return if @whole_space.between?(50, 300)

    raise 'Объем грузового вагона может быть в пределах от 50 до 300 '
  end
end
