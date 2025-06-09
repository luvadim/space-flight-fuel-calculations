require_relative 'starship_service'

class Calculate
  attr_reader :flight_ship_mass, :steps, :detailed_view

  def initialize(flight_ship_mass, steps, detailed_view: false)
    @flight_ship_mass = flight_ship_mass
    @steps = steps
    @detailed_view = detailed_view
  end

  def perform
    total_fuel = 0
    current_mass = flight_ship_mass

    steps.reverse.each do |step|
      action = step[0]
      planet = step[1]

      step_fuel = calculate_step_fuel(current_mass, action, planet)

      if detailed_view
        pp "Required fuel: #{total_fuel} for #{step[0]} on #{step[1]}"
      end

      total_fuel += step_fuel
      current_mass += step_fuel
    end

    if total_fuel > 0
      pp "Required fuel: #{total_fuel}"
    end
  end

  private

  def calculate_step_fuel(mass, action, planet)
    fuel_required = 0
    current_weight = mass

    loop do
      step_fuel = fuel_required_for_action(
        weight: current_weight,
        planet_gravity: planet_gravity(planet),
        action_type: action,
      ).floor

      break if step_fuel <= 0

      fuel_required += step_fuel
      current_weight = step_fuel
    end

    fuel_required
  end

  def fuel_required_for_action(weight:, planet_gravity:, action_type:)
    case action_type
    when :land
      weight * planet_gravity * 0.033 - 42
    when :launch
      weight * planet_gravity * 0.042 - 33
    else
      0
    end
  end

  def planet_gravity(planet)
    case planet.to_sym
    when :earth
      9.807
    when :moon
      1.62
    when :mars
      3.711
    else
      nil
    end
  end
end
