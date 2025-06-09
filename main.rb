require_relative 'input_collector'
require_relative 'calculate'

calculate = Calculate.new(InputCollector.get_flight_ship_mass, InputCollector.get_actions_and_destination_points, detailed_view: true)
calculate.perform
