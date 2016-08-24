class Mailer

  attr_reader :recipients

  def initialize

    @recipients = ENV['RECIPIENTS'].split(',')

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

  def compose(email)
    recipients << email.request[:producer_email]
    send(email.new_freelancer, recipients)
    recipients << email.request[:freelancer_email]
    send(email.one_sheet, recipients)
  end

  private

  def send(email, recipients)
    Mail.deliver do
      to      recipients.join(", ")
      from    "1stAveMachine <do-not-reply@1stavemachine.com>"
      subject email[:subject]
      if email[:cal_event]
        add_file filename: 'booking.ics', content: email[:cal_event]
      end

      text_part do
        body email[:body]
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body email[:body]
      end
    end
  end

end
