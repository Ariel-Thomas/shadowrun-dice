class NetSuccessCalculator
  class << self
    def net_attack_successes_hash attack_dice, defense_dice, limit=0
      net_successes_hash = {}

      attack_successes_hash = generate_successes_hash attack_dice
      defense_successes_hash = generate_successes_hash defense_dice

      attack_successes_hash.each do |attack_successes, attack_count|
        defense_successes_hash.each do |defense_successes, defense_count|
          net_successes = attack_successes - defense_successes

          if limit > 0
            net_successes = limit < net_successes ? limit : net_successes
          end

          current_count = net_successes_hash[net_successes]
          net_successes_hash[net_successes] = current_count ? current_count + (attack_count * defense_count) : (attack_count * defense_count )
        end
      end

      net_successes_hash
    end

    def generate_successes_hash number_of_dice
      successes_hash = {0 => 1.0}

      (number_of_dice).times do
        new_hash = {}

        {0 => (4.0/6.0), 1 => (2.0/6.0)}.each do |successes, result_count|
          successes_hash.each do |total_successes, total_result_count|
            current_successes = successes + total_successes
            current_count = new_hash[current_successes]
            new_hash[current_successes] = result_count * total_result_count + (current_count ? current_count : 0)
          end
        end

        successes_hash = new_hash
      end

      successes_hash
    end
  end
end