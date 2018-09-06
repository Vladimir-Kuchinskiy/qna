class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :created_at, :updated_at

  has_many :attachments, if: -> { show_attachments }
  has_many :comments, if: -> { show_comments }
  belongs_to :question, if: -> { show_question }

  private

  def show_attachments
    @instance_options[:show_attachments]
  end

  def show_comments
    @instance_options[:show_comments]
  end

  def show_question
    @instance_options[:show_question]
  end
end
