class TaskClosedMailer < ActionMailer::Base
  def message(contact, task, user)

    if user.id != contact.id
      mail(
        to: user.email,
        subject: "Task #{task.name} is closed by #{contact.first_name} #{contact.last_name}",
        from: from(contact)
      )
    end
  end

  private

  def from(contact)
    if contact.privacy_settings.exists?(hide_email: true)
      "no-reply.#{SecureRandom.uuid}-task-closed@flatstack.com"
    else
      contact.email
    end
  end
end
