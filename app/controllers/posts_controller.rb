require 'byebug'

class PostsController < ApplicationController
    include Secured
    before_action :authenticate_user!, only: [:create, :update]

    #Manejo de excepciones en rails
    #Esta excepción se ejecutará en todas las excepciones que no estén
    #manejadas por el programador
    rescue_from  Exception do |e |
        render json: { error: e.message }, status: :internal_error
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: { error: e.message }, status: :not_found
    end

    rescue_from  ActiveRecord::RecordInvalid do |e |
        render json: { error: e.message }, status: :unprocessable_entity
    end

    #Método para listar los posts, por convención es index
    # GET /posts
    def index
        @posts = Post.where(published: true)

        #Si dentro de los parámetros el dato 'search' no es nulo y está presente, haga lo siguiente:
        if !params[:search].nil? && params[:search].present?
            @posts = PostsSearchService.search(@posts, params[:search])
        end
        #Renderizar la información  a archivos json. Rails lo hace automáticamente
        #Explicación @posts.includes(:user) ->
            #Con esto se logra hacer una consulta a la BD para traer los posts
            #Y una consulta para traer la información de los usuarios relacionados
            #a los posts. Y con esto se resuelve el problema N + 1
        render json: @posts.includes(:user), status: :ok
    end

    #Método para mostrar los posts, por convención es show
    # GET /posts/{id}
    def show
        @post = Post.find(params[:id]) #ActiveRecord::RecordNotFound
        if (@post.published? || (Current.user && @post.user_id == Current.user.id))
            render json: @post, status: :ok
        else
            render json: { error: "Not Found" }, status: :not_found
        end
    end

    #Método que manejará la creación de un post
    # POST /posts
    def create
        @post = Current.user.posts.create!(create_params)
        render json: @post, status: :created
    end

    # PUT /posts/{id}
    def update
        @post = Current.user.posts.find(params[:id])
        @post.update!(update_params)
        render json: @post, status: :ok
    end

    private
    def create_params
        params.require(:post).permit(:title, :content, :published)
    end

    def update_params
        params.require(:post).permit(:title, :content, :published)
    end
end