class AttackCalculatorController < ApplicationController
  def show

  end

  def update
    @net_successes_hash = normalize_hash NetSuccessCalculator.net_attack_successes_hash(*attack_successes_params)
    @dv_probability_hash = normalize_hash AttackCalculator.dv_probability_hash(*dv_params)
    @damage_probability_hash = normalize_hash AttackCalculator.damage_probability_hash(*damage_params)
    @average_damage = AttackCalculator.average_damage(*damage_params)

    render :show
  end

  def attack_successes_params
    [params[:attack_dice].to_i, params[:defense_dice].to_i, params[:accuracy].to_i]
  end

  def dv_params
    [params[:attack_dice].to_i, params[:damage_value].to_i, params[:defense_dice].to_i, params[:accuracy].to_i]
  end

  def damage_params
    [params[:attack_dice].to_i, params[:damage_value].to_i, params[:defense_dice].to_i, params[:soak_dice].to_i, params[:accuracy].to_i]
  end

  def normalize_hash hash
    hash.each{ |k,v| hash[k] = (v * 100).round(2)}.sort
  end
end