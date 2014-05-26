ShadowrunDice::Application.routes.draw do
  root 'attack_calculator#show'

  post controller: :attack_calculator, action: :update, as: :attack_calculator
end
