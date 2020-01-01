require "rails_helper"
require "byebug"

RSpec.describe "Posts", type: :request do

    describe "GET /posts" do
        before { get '/posts' }

        it "should return OK" do
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(200)
        end

    end

    describe "with data in the DB" do
        #Se utilizará factory_bot para crear información  de ejemplo
        #Se utiliza para declarar una variable 'posts' a la cual se le asignará lo que 
        #se ponga dentro del bloque

        #Diferencia entre let y let!
        #El bloque dentro del let se hará una 'lazy evaluation', solo se crearán la información
        #cuando sea necesaria.
        #Mientras que con let! la información existirá siempre y se podrá acceder a ella en todo 
        #momento


        #Método let pertenece a la gema 'rspec'
        let!(:posts) { 
            #Esto es el bloque
            #create_list pertenece a la gema 'factory_bot'
            create_list(:post, 10, published: true)
        }

        it "should return all the published posts" do
            #byebug
            #Se hace el request a la BD
            get '/posts'

            #En este caso el payload sería una lista de posts
            payload = JSON.parse(response.body)
            #Se debe esperar que el 'payload' sea igual al tamaño
            #del símbolo :posts
            expect(payload.size).to eq(posts.size)
            expect(response).to have_http_status(200)
        end
    end

    describe "GET /post/{id}" do
        #Se utilizará factory_bot para crear posts de ejemplo
        let!(:post) { create(:post) }
     
        it "should return a post" do
            get "/posts/#{post.id}"
            payload = JSON.parse(response.body)
            #Verificar que el payload no esté vacío
            expect(payload).to_not be_empty
            expect(payload["id"]).to eq(post.id)
            expect(response).to have_http_status(200)
        end
    end
end