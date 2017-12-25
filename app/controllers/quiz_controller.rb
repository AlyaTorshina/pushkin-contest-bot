class QuizController < ApplicationController

  def history
    @history = History.paginate(:page => params[:page], :per_page => 15)
  end

  def index
    starting_time = Time.now
    question = params[:question]
    id = params[:id]
    level = params[:level]
    case level
    when 1
      question_new = question.tr(" ","")
      answer = LineWithTitle.find_by(line: question_new)
      answer = if answer
                 answer.title
               else
                 ""
               end
    when 2..4
      lines = question.split("\n")
      answer = []
      lines.each do |line|
        tmp = MissingWord.find_by(question: line)
        if tmp
          answer << tmp.answer
        else
          answer << ""
        end
      end
      answer = answer.join(",")
    when 5
      question_new = question.split(" ")
      answer = ''
      question_new.each do |word|
        str = question.gsub(word, "%WORD%")
        tmp = MissingWord.find_by(question: str)
        if tmp
          original_word = tmp.answer
          answer = "#{original_word},#{word}"
          return
        end
      end
    when 6..7
      question_new = question.split("").sort.join
      answer = SortedLine.find_by(sorted_line: question_new)
      answer = if answer
                 answer.line
               else
                 ""
               end
    when 8
      question_new = question.split("").sort.join
      left_part = question_new[0..((question_new.length)/2)]
      right_part = question_new[((question_new.length)/2 + 1)..-1]
      query_part = "'#{left_part}%' OR sorted_line LIKE '%#{right_part}'"
      answer = SortedLine.find_by("sorted_line LIKE #{ query_part }")
      answer = if answer
                 answer.line
               else
                 ""
               end
    end
    uri = URI("http://pushkin.rubyroidlabs.com/quiz")
    parameters = {
      answer: answer,
      token: "12785e2bc09f06b9c0719a31414745ce",
      task_id: id
    }
    Net::HTTP.post_form(uri, parameters)
    History.create(question: question, identifier: id, level: level, time: Time.now - starting_time, answer: answer)
    render json: 'completed'
  end
end
