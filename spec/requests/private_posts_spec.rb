require "rails_helper"

RSpec.describe "Posts with authentication", type: :request do

    #Creando usuarios y posts de prueba
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:user_post) { create(:post, user_id: user.id) }
    let!(:other_user_post) { create(:post, 
        user_id: other_user.id, published: true) }
    let!(:other_user_post_draft) { create(:post, 
        user_id: other_user.id, published: false) }
    #Headers de autenticación
    let!(:auth_headers) { { 'Authorization' => 
        "Bearer #{user.auth_token}" } }
    let!(:other_auth_headers) { { 'Authorization' => 
        "Bearer #{other_user.auth_token}" } }

    #Prueba para el detalle de posts
    describe "GET /posts/{id}" do
        context "with valid auth" do
            context "when requisting other's author post" do
                context "when post is public" do
                    before { get "/posts/#{other_user_post.id}", 
                    headers: auth_headers }
                    context "payload" do
                        subject { payload }
                        #Validación para el payload
                        it { is_expected.to include(:id) }
                    end
                    #Respuesta
                    context "response" do
                        subject { response } 
                        it { is_expected.to have_http_status(:ok) }
                    end
                end
                context "when post is draft" do
                    before { get "/posts/#{other_user_post_draft.id}", 
                    headers: auth_headers }
                    context "payload" do
                        subject { payload }
                        #Validación para el payload
                        it { is_expected.to include(:error) }
                    end
                    #Respuesta
                    context "response" do
                        subject { response } 
                        it { is_expected.to have_http_status(:not_found) }
                    end
                end
            end

            context "when requisting user's post" do
            end
        end
    end

    #Prueba para la creación de posts
    describe "POST /posts" do
    end

    #Prueba para la actualización de posts
    describe "PUT /posts" do
    end

    private
    def payload
        JSON.parse(response.body).with_indifferent_access
    end
end