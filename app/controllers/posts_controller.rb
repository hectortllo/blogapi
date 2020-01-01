class PostsController < ApplicationController

    #Método para listar los posts, por convención es index
    # GET /post
    def index
        @posts = Post.where(published: true)
        #Renderizar la información  a archivos json. Rails lo hace automáticamente
        render json: @posts, status: :ok
    end

    #Método para mostrar los posts, por convención es show
    # GET /post/{id}
    def show
        @post = Post.find(params[:id])
        render json: @post, status: :ok
    end
end