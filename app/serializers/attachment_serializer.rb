class AttachmentSerializer < ActiveModel::Serializer
  attributes :file_url

  belongs_to :attachable

  def file_url
    object.file.url
  end
end
