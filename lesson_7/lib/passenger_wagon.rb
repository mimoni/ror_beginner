# frozen_string_literal: true

class PassengerWagon < Wagon
  def initialize(amount_seats = 20)
    super(:passenger, amount_seats)
  end

  def to_s
    %(номер вагона:#{@name} тип: пассажирский,
      свободных мест: #{available_space} занятых мест: #{@taken_space})
  end

  protected

  def validate!
    return if @whole_space.between?(20, 64)

    raise 'Кол-во мест в пассажирском вагоне может быть в пределах от 20 до 64'
  end
end
