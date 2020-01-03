class PostReport < Struct.new(:word_count, :word_histogram)
  #Histograma -> Guardará cuántas veces aparece repetida una palabra
  def self.generate(post)
    PostReport.new(
      #word_count
      #Reemplazar signos de puntuación
      post.content.split.map { |word| word.gsub(/\W/,'') }.count,
      #word_histogram
      calc_histogram(post)
    )
  end

  def self.calc_histogram(post)
    (post
      .content
      .split
      .map { |word| word.gsub(/\W/,'') }
      .map(&:downcase)
      .group_by { |word| word })
      .transform_values(&:size)
  end
end