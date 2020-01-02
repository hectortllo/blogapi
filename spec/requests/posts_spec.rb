require "rails_helper"

RSpec.describe "Posts", type: :request do

    #Prueba para listar todos los posts
    describe "GET /posts" do
        it "should return OK" do
            get '/posts'
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(200)
        end

        #Prueba para la búsqueda de posts
        describe "Search" do
            let!(:hola_mundo) { create(:published_post, title: 'Hola Mundo') }
            let!(:hola_rails) { create(:published_post, title: 'Hola Rails') }
            let!(:curso_rails) { create(:published_post, title: 'Curso Rails') }

            it "should filter posts by title " do
                get "/posts?search=Hola"
                payload = JSON.parse(response.body)
                expect(payload).to_not be_empty
                expect(payload.size).to eq(2)
                expect(payload.map { |p| p["id"] }.sort).to eq([hola_mundo.id, hola_rails.id].sort)
                expect(response).to have_http_status(200)
            end
        end
    end


    #Prueba para listar los posts, pero teniendo información de la BD
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

    #Prueba para mostar un post individualmente
    describe "GET /post/{id}" do
        #Se utilizará factory_bot para crear posts de ejemplo
        let!(:post) { create(:post, published: true) }
     
        it "should return a post" do
            get "/posts/#{post.id}"
            payload = JSON.parse(response.body)
            #Verificar que el payload no esté vacío
            expect(payload).to_not be_empty
            expect(payload["id"]).to eq(post.id)
            expect(payload["title"]).to eq(post.title)
            expect(payload["content"]).to eq(post.content)
            expect(payload["published"]).to eq(post.published)
            expect(payload["author"]["name"]).to eq(post.user.name)
            expect(payload["author"]["email"]).to eq(post.user.email)
            expect(payload["author"]["id"]).to eq(post.user.id)
            expect(response).to have_http_status(200)
        end
    end
end