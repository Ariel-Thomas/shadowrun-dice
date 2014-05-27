class RegistrationCalculator
  class << self
    def chance_of_success(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes)
      total = 0

      compiling_and_registration_successes_after_damage_hash(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes).each do |successes, probability|
        total = total + probability if successes > 0
      end

      (total * 100).round(3)
    end


    def average_favors(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes)
      total = 0

      compiling_and_registration_successes_after_damage_hash(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes).each do |successes, probability|
        total = total + successes * probability
      end

      total.round(3)
    end


    def compiling_and_registration_successes_after_damage_hash(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes)
      net_successes_hash = {}

      compiling_net_successes_and_damage_hash(compiling_dice, sprite_level, fade_resistance_dice, health_boxes).each do |net_successes, damage_hash|

        puts net_successes.to_s if net_successes > 10

        damage_hash.each do |damage, probability|
          net_registration_dice = registration_dice - (damage / 3)

          NetSuccessCalculator.net_attack_successes_with_defense_successes_hash(net_registration_dice, sprite_level * 2, sprite_level).each do |registration_successes, defense_hash|

            if net_successes < 0
              registration_successes = 0
            else
              registration_successes = registration_successes + net_successes
            end

            defense_hash.each do |defense_successes, defense_probability|
              dv = (defense_successes * 2) > 2 ? (defense_successes * 2) : 2
              NetSuccessCalculator.generate_successes_hash(fade_resistance_dice).each do |soak_successes, soak_probability|


                net_damage = dv - soak_successes + damage
                net_damage = net_damage > 0 ? net_damage : 0
                if net_damage >= health_boxes
                  registration_successes = 0
                end

                current_count = net_successes_hash[registration_successes]
                net_successes_hash[registration_successes] = (probability * defense_probability * soak_probability) + (current_count ? current_count : 0)

              end
            end
          end
        end
      end

      net_successes_hash
    end



    def compiling_and_registration_net_successes_hash(compiling_dice, registration_dice, sprite_level, fade_resistance_dice, health_boxes)

      net_successes_hash = {}

      compiling_net_successes_and_damage_hash(compiling_dice, sprite_level, fade_resistance_dice, health_boxes).each do |net_successes, damage_hash|
        damage_hash.each do |damage, probability|
          net_registration_dice = registration_dice - (damage / 3)

          NetSuccessCalculator.net_attack_successes_hash(net_registration_dice, sprite_level * 2, sprite_level).each do |successes, successes_probability|

            if net_successes < 0
              successes = 0
            else
              successes = successes + net_successes
            end

            current_count = net_successes_hash[successes]
            net_successes_hash[successes] = (probability * successes_probability) + (current_count ? current_count : 0)
          end
        end
      end

      net_successes_hash
    end

    def compiling_net_successes_after_damage_hash(compiling_dice, sprite_level, fade_resistance_dice, health_boxes)
      successes_hash = {}

      compiling_net_successes_and_damage_hash(compiling_dice, sprite_level, fade_resistance_dice, health_boxes).each do |net_successes, damage_hash|

        successes_hash[net_successes] = damage_hash.values.inject { |a, b| a + b }
      end

      successes_hash
    end

    def compiling_net_successes_and_damage_hash(compiling_dice, sprite_level, fade_resistance_dice, health_boxes)
      net_compiling_successes_with_defense_hash = NetSuccessCalculator.net_attack_successes_with_defense_successes_hash(compiling_dice, sprite_level, sprite_level)

      net_successes_with_defense_hash = {}

      net_compiling_successes_with_defense_hash.each do |net_successes, defense_hash|
        defense_hash.each do |defense_successes, probability|
          dv = (defense_successes * 2) > 2 ? (defense_successes * 2) : 2

          NetSuccessCalculator.generate_successes_hash(fade_resistance_dice).each do |successes, successes_probability|

            net_damage = dv - successes
            net_damage = net_damage > 0 ? net_damage : 0

            if net_damage >= health_boxes
              net_successes = 0
            end

            current_penalty_hash = net_successes_with_defense_hash[net_successes]
            unless current_penalty_hash
              current_penalty_hash = {}
              net_successes_with_defense_hash[net_successes] = {}
            end
            current_count = current_penalty_hash[net_damage]

            net_successes_with_defense_hash[net_successes][net_damage] =  (probability * successes_probability ) + (current_count ? current_count : 0)
          end
        end
      end

      net_successes_with_defense_hash
    end
  end
end

