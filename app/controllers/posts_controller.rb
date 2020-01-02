class PostsController < ApplicationController

    #Manejo de excepciones en rails
    #Esta excepción se ejecutará en todas las excepciones que no estén
    #manejadas por el programador
    rescue_from  Exception do |e |
        render json: { error: e.message }, status: :internal_error
    end

    rescue_from  ActiveRecord::RecordInvalid do |e |
        render json: { error: e.message }, status: :unprocessable_entity
    end

    #Método para listar los posts, por convención es index
    # GET /posts
    def index
        @posts = Post.where(published: true)
        #Renderizar la información  a archivos json. Rails lo hace automáticamente
        render json: @posts, status: :ok
    end

    #Método para mostrar los posts, por convención es show
    # GET /posts/{id}
    def show
        @post = Post.find(params[:id])
        render json: @post, status: :ok
    end

    #Método que manejará la creación de un post
    # POST /posts
    def create
        @post = Post.create!(create_params)
        render json: @post, status: :created
    end

    # PUT /posts/{id}
    def update
        @post = Post.find(params[:id])
        @post.update!(update_params)
        render json: @post, status: :ok
    end

    private
    def create_params
        params.require(:post).permit(:title, :content, :published, :user_id)
    end

    def update_params
        params.require(:post).permit(:title, :content, :published)
    end
    
end