class DeathCalculator
  class << self
    def chance_of_death damage_hash, health_boxes
      total = 0

      damage_hash.each do |damage, probability|
        total = total + probability if (damage >= health_boxes)
      end

      total.round(3)
    end
  end
end