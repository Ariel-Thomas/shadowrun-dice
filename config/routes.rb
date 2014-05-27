ShadowrunDice::Application.routes.draw do
  root 'attack_calculator#show'

  scope :attack_calculator, as: :attack_calculator do
    get  controller: :attack_calculator, action: :show
    post controller: :attack_calculator, action: :update
  end

  scope :sprite_registration_calculator, as: :sprite_registration_calculator do
    get  controller: :sprite_registration_calculator, action: :show
    post controller: :sprite_registration_calculator, action: :update
  end
end
