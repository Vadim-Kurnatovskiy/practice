class Audit
  def archive!
    update_status('archive')
    if save
      destroy_todos
      unlock_attachment_documents
      release_lock
      update_project_roles
    end
  end

  private

  def update_status(status)
    self.status = status
  end

  def destroy_todos
    todos.destroy_all
    destroy_old_attachment_versions
  end

  def unlock_attached_documents
    attached_documents.reload.each(&:unlock!)
  end

  def release_lock
    objectives.each(&:release_lock!)
  end

  def update_project_roles
    project_roles.includes(:relationship).each do |r|
      r.update_attributes(:name => 'reviewer')
    end
  end
end