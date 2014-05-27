class FadeCalculator
  class << self
    def average_fade_damage sprite_level, fade_resistance_dice
      total = 0

      compiling_and_registration_fade_damage_hash(sprite_level, fade_resistance_dice).each do |damage, probability|
        total = total + damage * probability
      end

      total.round(3)
    end

    def compiling_and_registration_fade_damage_hash sprite_level, fade_resistance_dice
      total_dv_hash = {}

      net_compiling_fade_damage_hash(sprite_level, fade_resistance_dice).each do |compiling_damage, compiling_probability|
        net_registration_fade_damage_hash(sprite_level, fade_resistance_dice).each do |registration_damage, registration_probability|

          puts registration_damage.to_s if registration_damage > 10

          net_dv = compiling_damage + registration_damage
          current_count = total_dv_hash[net_dv]

          total_dv_hash[net_dv] = (compiling_probability * registration_probability) + (current_count ? current_count : 0)
        end
      end

      total_dv_hash
    end


    def net_registration_fade_damage_hash sprite_level, fade_resistance_dice
      dv_hash = registration_fade_dv_hash(sprite_level)

      probability_hash = {}

      dv_hash.each do |dv, dv_probability|
        NetSuccessCalculator.generate_successes_hash(fade_resistance_dice).each do |successes, successes_probability|
          net_damage = dv - successes
          net_damage = net_damage > 0 ? net_damage : 0
          current_count = probability_hash[net_damage]

          probability_hash[net_damage] = (dv_probability * successes_probability) + (current_count ? current_count : 0)
        end
      end

      probability_hash
    end

    def registration_fade_dv_hash sprite_level
      probability_hash = NetSuccessCalculator.generate_successes_hash sprite_level * 2
      dv_hash = {}

      probability_hash.each do |successes, probability|
        dv = (successes > 1) ? (successes * 2) : 2
        current_probability = dv_hash[dv]
        dv_hash[dv] = probability + (current_probability ? current_probability : 0)
      end

      dv_hash
    end


    def net_compiling_fade_damage_hash sprite_level, fade_resistance_dice
      dv_hash = compiling_fade_dv_hash(sprite_level)

      probability_hash = {}

      dv_hash.each do |dv, dv_probability|
        NetSuccessCalculator.generate_successes_hash(fade_resistance_dice).each do |successes, successes_probability|
          net_damage = dv - successes
          net_damage = net_damage > 0 ? net_damage : 0
          current_count = probability_hash[net_damage]

          probability_hash[net_damage] = (dv_probability * successes_probability) + (current_count ? current_count : 0)
        end
      end

      probability_hash
    end

    def compiling_fade_dv_hash sprite_level
      probability_hash = NetSuccessCalculator.generate_successes_hash sprite_level
      dv_hash = {}

      probability_hash.each do |successes, probability|
        dv = (successes > 1) ? (successes * 2) : 2
        current_probability = dv_hash[dv]
        dv_hash[dv] = probability + (current_probability ? current_probability : 0)
      end

      dv_hash
    end
  end
end