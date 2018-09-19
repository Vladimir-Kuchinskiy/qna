# frozen_string_literal: true

class ConvertAttachmentToPolymorphic < ActiveRecord::Migration[5.2]
  def change
    remove_index  :attachments, :question_id
    rename_column :attachments, :question_id, :attachable_id

    add_column :attachments, :attachable_type, :string
    add_index  :attachments, %i[attachable_type attachable_id]
  end
end
