class FirstContactMailer < ActionMailer::Base
  def message(user, contact)

    if user.id != contact.id
      mail(
        to: contact.email,
        subject: "Hello from #{user.first_name} #{user.last_name}",
        from: from
      )
    end
  end

  private

  def from
    "no-reply.#{SecureRandom.uuid}-first-contact@flatstack.com"
  end
end
