class WordsController < ApplicationController
  respond_to :json # AJAX only

  def index
    words = Word.all
    respond_with words
  end

  def show
    word = Word.all.sample
    respond_with word
  end

  def create
    # num = rand(10)
    # if num % 3 == 0
    #   word = Word.all.sample
    # else
    #   word = Word.create
    # end

    word = Word.all.sample
    url = Wordnik.word.get_audio("#{word.word}")

    # while url.empty?
    #   word.destroy
    #   word = Word.create
    #   sleep 0.5
    #   url = Wordnik.word.get_audio("#{word.word}")
    # end

    definitions = []

    Wordnik.word.get_definitions("#{word.word}", limit: 3).each do |definition|
      definitions << definition["text"]
    end

    NewWord.perform_async
    render json: {word: word, url: url.last["fileUrl"], definitions: definitions}
  end

  def update
    word = Word.find(params[:id])
    word.update_attributes(correct: params[:correct], incorrect: params[:incorrect])
    respond_with word
  end
end
