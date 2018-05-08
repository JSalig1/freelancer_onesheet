class Email

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def new_freelancer
    {
      subject: "New Booking | #{full_name} | #{request[:project_name]}",
      body: freelancer_info,
      cal_event: create_event
    }
  end

  def one_sheet
    if request[:dicipline] == 'producer'
      {
        subject: "Producer One Sheet | #{full_name}",
        body: producer_one_sheet_info
      }
    else
      {
        subject: "Freelancer One Sheet | #{full_name}",
        body: one_sheet_info
      }
    end
  end

  private

  def full_name
    request[:first_name] + " " +  request[:last_name]
  end

  def freelancer_info
    "
    New Freelancer info for #{request[:project_name]}:\n<br><br>
    Name: #{full_name}\n<br>
    Email: #{request[:freelancer_email]}\n\n<br><br>
    Discipline: #{request[:dicipline]}\n<br>
    Project: #{request[:project_name]}\n<br>
    Workstation: #{request[:workstation]}\n<br>
    Booking Duration: #{request[:booking_start]} - #{request[:booking_end]}\n<br><br>
    Other Hardware/Software needs and notes: #{request[:other_needs]}\n\n<br><br>
    Submitted by: #{request[:sender]}
    "
  end

  def producer_one_sheet_info
    #to be written later for now we'll leave the old one in place.
    one_sheet_info
  end

  def one_sheet_info

    credentials = Credential.new(request)

    if request[:office] == "LA"
      server_name = "zebes"
    else
      server_name = "gary"
    end

    "
    Please Acknowledge and Confirm<br><br>
    <strong>Freelance One Sheet:</strong><br><br>

    Name: #{full_name}<br>
    Email: #{request[:freelancer_email]}<br>
    Booking Dates: #{request[:booking_start]} through #{request[:booking_end]}<br><br>

    <strong>1stAve User Credentials:</strong><br><br>

    Username: #{credentials.username}<br>
    Password: #{credentials.password}<br><br>

    Use this to log into workstations, the server and the '!STAVE' Wi-Fi Network.<br><br>

    <strong>Project infomation:</strong><br><br>

    Project: #{request[:project_name]}<br>
    Project path: \\\\#{server_name}\\main\\JOBS\\#{request[:project_name]}<br><br>

    Workstation: #{request[:workstation]}<br><br>

    <strong>Folder Naming Conventions:</strong><br><br>
    Dated Folders should be:<br>
    [YEAR][MONTH][DAY]<br><br>

    When creating any other folders / files<br><br>
    ONLY USE:<br>
    LETTERS NUMBERS and UNDERSCORE. NO SPACES<br><br>

    EX: this_is_an_example04<br>
    "
  end

  def create_event
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = DateTime.parse(start_date)
      e.dtend       = DateTime.parse(end_date)
      e.summary     = "#{full_name} | #{request[:project_name]}"
      e.description = "#{request[:notes]}"
      e.organizer   = "mailto:#{request[:producer_email]}"
    end

    cal.to_ical

  end

  def start_date
    stringify(request[:booking_start]) + "T100000"
  end

  def end_date
    stringify(request[:booking_end]) + "T190000"
  end

  def stringify(form_date)
    form_date.split("/").rotate(2).join
  end

end
