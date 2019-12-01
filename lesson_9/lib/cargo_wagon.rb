# frozen_string_literal: true

class CargoWagon < Wagon
  validate :whole_space, :custom, lambda { |volume|
    error_message = 'Объем грузового вагона может быть в пределах от 50 до 300 '
    raise error_message unless volume.between?(50, 300)
  }

  def initialize(volume = 100)
    super(:cargo, volume)
  end

  def to_s
    %(номер вагона:#{@name} тип: грузовой,
      кол-во свободного объема: #{available_space} занятого объема: #{@taken_space})
  end
end
