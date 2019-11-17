class PassengerWagon < Wagon
  def initialize(amount_seats = 20)
    @amount_seats = amount_seats
    @taken_seats = 0
    super(PassengerTrain)
  end

  def take_place
    @taken_seats += 1 if @taken_seats < @amount_seats
  end

  def occupied_places
    @taken_seats
  end

  def available_places
    @amount_seats - @taken_seats
  end

  def to_s
    "номер вагона:#{@name} тип: пассажирский, свободных мест: #{available_places} занятых мест: #{occupied_places}"
  end

  protected

  def validate!
    raise 'Кол-во мест в пассажирском вагоне может быть в пределах от 20 до 64' unless @amount_seats.between?(20, 64)
  end
end
