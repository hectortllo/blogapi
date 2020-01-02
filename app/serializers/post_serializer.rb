class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  def author
    #Hace referencia al post que está siendo serializado
    user = self.object.user
    {
      name: user.name,
      email: user.email,
      id: user.id 
    }
  end
end
