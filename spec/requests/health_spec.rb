require "rails_helper"

#Realizando una prueba de integración
RSpec.describe "Health endpoint", type: :request do
    describe "GET /health" do
        before { get '/health' }

        #Probar que el código que va dentro debe retornar un 'ok'
        #en el estandar de HTTP, es un 200
        it "should return OK" do
            payload = JSON.parse(response.body)
            expect(payload).not_to be_empty
            expect(payload['api']).to eq('OK')
        end

        it "should return status code 200" do
            expect(response).to have_http_status(200)
        end
    end
end