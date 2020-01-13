class Audit
  def archive!
    self.status = 'archive'
    if save
      todos.destroy_all
      destroy_old_attachment_versions
      attached_documents.reload.each(&:unlock!)
      objectives.each(&:release_lock!)
      project_roles.includes(:relationship).each do |r|
        r.update_attributes(:name => 'reviewer')
      end
    end
  end
end
