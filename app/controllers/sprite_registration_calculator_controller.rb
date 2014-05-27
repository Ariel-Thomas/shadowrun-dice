class SpriteRegistrationCalculatorController < ApplicationController
  def show

  end

  def update
    @compiling_fade_dv_hash = normalize_hash FadeCalculator.compiling_fade_dv_hash(*fade_dv_params)
    @net_compiling_fade_damage_hash = normalize_hash FadeCalculator.net_compiling_fade_damage_hash(*net_fade_damage_params)

    @registration_fade_dv_hash = normalize_hash FadeCalculator.registration_fade_dv_hash(*fade_dv_params)
    @net_registration_fade_damage_hash = normalize_hash FadeCalculator.net_registration_fade_damage_hash(*net_fade_damage_params)

    @compiling_and_registration_fade_damage_hash = normalize_hash FadeCalculator.compiling_and_registration_fade_damage_hash(*net_fade_damage_params)
    @average_fade_damage = FadeCalculator.average_fade_damage(*net_fade_damage_params)
    @chance_of_death = DeathCalculator.chance_of_death(*chance_of_death_params)


    @compiling_net_successes = normalize_hash NetSuccessCalculator.net_attack_successes_hash(*compiling_params)
    @compiling_net_successes_after_damage = normalize_hash RegistrationCalculator.compiling_net_successes_after_damage_hash(*compiling_after_damage_params)
    @compiling_and_registration_net_successes = normalize_hash RegistrationCalculator.compiling_and_registration_net_successes_hash(*registration_params)
    @compiling_and_registration_successes_after_damage = normalize_hash RegistrationCalculator.compiling_and_registration_successes_after_damage_hash(*registration_params)

    @average_favors = RegistrationCalculator.average_favors(*registration_params)
    @chance_of_success = RegistrationCalculator.chance_of_success(*registration_params)


    render :show
  end

  def fade_dv_params
    [params[:sprite_level].to_i]
  end

  def net_fade_damage_params
    [params[:sprite_level].to_i, params[:fade_resistance_dice].to_i]
  end

  def chance_of_death_params
    [@compiling_and_registration_fade_damage_hash, params[:health_boxes].to_i]
  end

  def compiling_params
    [params[:compiling_dice].to_i, params[:sprite_level].to_i, params[:sprite_level].to_i]
  end

  def compiling_after_damage_params
    [params[:compiling_dice].to_i, params[:sprite_level].to_i, params[:sprite_level].to_i, params[:health_boxes].to_i]
  end

  def registration_params
    [params[:compiling_dice].to_i, params[:registration_dice].to_i, params[:sprite_level].to_i, params[:fade_resistance_dice].to_i, params[:health_boxes].to_i]
  end


  def normalize_hash hash
    hash.each{ |k,v| hash[k] = (v * 100).round(2)}.sort
  end
end