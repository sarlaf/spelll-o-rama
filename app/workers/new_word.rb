class NewWord
  include Sidekiq::Worker

  def perform
    word = Word.create
    url = Wordnik.word.get_audio("#{word.word}")

    while url.empty?
      word.destroy
      word = Word.create
      sleep 2
      url = Wordnik.word.get_audio("#{word.word}")
    end

  end
end