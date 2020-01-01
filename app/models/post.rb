class Post < ApplicationRecord
  belongs_to :user

  #Llamando a las pruebas hechas en el archivo post_spec.rb
  validates :title, presence: :true
  validates :content, presence: :true
  validates :published, presence: :true
  validates :user_id, presence: :true
end
