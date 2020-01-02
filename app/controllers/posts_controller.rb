class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update]

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
   
    def authenticate_user!
        #Bearer xxxx
        token_regex = /Bearer (\w+)/
        #leer HEADER de autenticación 
        headers = request.headers
        #verificar que sea válido
        if headers['Authorization'].present? && 
            headers['Authorization'].match(token_regex)
            token = headers['Authorization'].match(token_regex)[1]
            #verificar que el token corresponda a un usuario
            if(Current.user = User.find_by_auth_token(token))
                return
            end
        end

        render json: { error: 'Unauthorized' }, status: :unauthorized        


    end
end