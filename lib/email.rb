class Email

  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def body
    "
    New Freelancer info:\n<br><br>
    Name: #{request[:first_name]} #{request[:last_name]}\n<br>
    Email: #{request[:e_mail]}\n\n<br><br>
    Dicipline: #{request[:dicipline]}\n<br>
    Project: #{request[:project_name]}\n<br>
    Workstation: #{request[:workstation]}\n<br>
    Booking Duration: #{request[:booking_duration]}\n<br>
    Other Hardware/Software needs: #{request[:other_needs]}\n\n<br><br>
    Submitted by: #{request[:sender]}
    "
  end

end
