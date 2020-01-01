require 'rails_helper'

RSpec.describe User, type: :model do
  
  #Dándole contexto a la prueba
  describe "validations" do
    #Definir la prueba en sí
    it "valide presence of required fields" do
      should validate_presence_of(:email)
      should validate_presence_of(:name)
      should validate_presence_of(:auth_token)
    end

    it "validate relation" do
      should have_many(:posts)
    end
  end
end
