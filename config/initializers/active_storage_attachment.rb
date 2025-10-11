Rails.application.config.to_prepare do
  # Reopen class, không override
  # Chỉ chạy nếu ActiveStorage::Attachment đã load
  ActiveStorage::Attachment.class_eval do
    acts_as_list scope: [ :record_type, :record_id ]
    default_scope { order(:position) }
  end
end
