class InputCollector
  PLANET = ['earth', 'moon', 'mars'].freeze

  class << self
    def get_flight_ship_mass
      pp 'flight ship mass: '
      gets.chomp.to_i
    end

    def get_actions_and_destination_points
      pp 'action + destination point like that [[:launch, "earth"], [:land, "moon"]]: '
      input = eval(gets.chomp)

      parse_and_validate_input(input)
    end

    private

    def parse_and_validate_input(input)
      unless valid_steps?(input)
        raise ArgumentError, "Input must be an array of [:action, destination] pairs"
      end

      if invalid_action_sequence?(input)
        raise ArgumentError, "You should have sequence launch -> land, land -> launch"
      end

      if unknown_planet?(input)
        raise ArgumentError, "Your trip contains unknown planet"
      end

      input
    rescue ArgumentError => e
      puts "Invalid input: #{e.message}"
      []
    end

    def unknown_planet?(steps)
      steps.any? { |_, planet| !PLANET.include?(planet) }
    end

    def valid_steps?(steps)
      steps.is_a?(Array) && steps.all? do |step|
        step.is_a?(Array) && step.size == 2 && step[0].is_a?(Symbol) && step[1].is_a?(String)
      end
    end

    def invalid_action_sequence?(actions)
      # after each launch should be land
      # after each land should be launch
      # you can't land twice in a row
      return false if actions.empty? || actions.size == 1

      actions.each_cons(2).all? do |a, b|
        (a == :launch && b == :land) || (a == :land && b == :launch)
      end
    end
  end
end