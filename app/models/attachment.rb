class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader

  def self.has_files?
    all.map{ |a| a[:file] }.any?
  end
end
