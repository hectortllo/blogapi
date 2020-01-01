class Post < ApplicationRecord
  belongs_to :user

  #Llamando a las pruebas hechas en el archivo post_spec.rb
  validates :title, presence: :true
  validates :content, presence: :true
  validates :user_id, presence: :true
  
  #En el caso de los datos booleanos se debe usar la siguiente nomenclatura
  validates :published, inclusion: { in: [true, false] } 
end
