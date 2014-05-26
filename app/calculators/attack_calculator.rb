class AttackCalculator
  class << self
    def average_damage attack_dice, damage, defense_dice, soak, accuracy=7
      total = 0

      damage_probability_hash(attack_dice, damage, defense_dice, soak, accuracy).each do |dv, probability|
        total = total + dv * probability
      end

      total.round(3)
    end

    def damage_probability_hash attack_dice, damage, defense_dice, soak, accuracy=7
      dv_hash = dv_probability_hash(attack_dice, damage, defense_dice, accuracy)

      probability_hash = {}

      dv_hash.each do |total_damage, probability|
        NetSuccessCalculator.generate_successes_hash(soak).each do |successes, successes_probability|
          net_damage = total_damage - successes
          net_damage = net_damage > 0 ? net_damage : 0
          current_count = probability_hash[net_damage]

          probability_hash[net_damage] = (probability * successes_probability) + (current_count ? current_count : 0)
        end
      end

      probability_hash
    end

    def dv_probability_hash attack_dice, damage, defense_dice, accuracy=7
      net_successes_probability_hash = NetSuccessCalculator.net_attack_successes_hash attack_dice, defense_dice, accuracy

      probability_hash = {}

      net_successes_probability_hash.each do |net_successes, probability|
        dv = net_successes > 0 ? damage + net_successes : 0
        current_count = probability_hash[dv]

        probability_hash[dv] = current_count ? current_count + probability : (probability)
      end

      probability_hash
    end
  end
end