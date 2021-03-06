class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def history
    @history = History.paginate(:page => params[:page], :per_page => 50)
  end

  def index
    question = params["question"]
    id = params["id"]
    level = params["level"].to_i
    answer = nil
    case level
    when 1
      question_new = question.tr(" ","")
      question_new.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
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
        line.gsub!(/[\«\»\~\!\@\#\$\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
        tmp = MissingWord.find_by(question: line)
        if tmp
          answer << tmp.answer
        else
          answer << ""
        end
      end
      answer = answer.join(",")
    when 5
      q_without_punctuation = question.gsub(/[\«\»\~\!\@\#\$\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
      question_new = q_without_punctuation.split(" ")
      answer = ''
      question_new.each do |word|
        str = q_without_punctuation.gsub(word, "%WORD%")
        tmp = MissingWord.find_by(question: str)
        if tmp
          original_word = tmp.answer
          answer = "#{original_word},#{word}"
          break
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
    uri = URI('http://pushkin.rubyroidlabs.com/quiz')

    parameters = {
      answer: answer,
      token: "12785e2bc09f06b9c0719a31414745ce",
      task_id: id
    }
    response = Net::HTTP.post_form(uri, parameters)
    render json: 'completed'
    History.create(question: question, identifier: id, level: level, answer: answer)

  end
end
