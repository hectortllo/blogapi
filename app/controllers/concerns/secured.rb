module Secured
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