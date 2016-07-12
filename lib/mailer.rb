class Mailer

  def initialize
    Mail.defaults do
      delivery_method :smtp, {
        port:         587,
        address:      "smtp.gmail.com",
        user_name:    ENV['USER_NAME'],
        password:     ENV['PASSWORD'],
        authentication:    "plain",
        enable_starttls_auto:    true
      }
    end
  end

  def send(email)
    Mail.deliver do
      to      "#{ENV['RECIPIENTS']}"
      from    "1stAveMachine <do-not-reply@1stavemachine.com>"
      subject "New Freelancer info for #{email.request[:project_name]}"

      text_part do
        body "#{email.body}"
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body "#{email.body}"
      end
    end
  end

end
