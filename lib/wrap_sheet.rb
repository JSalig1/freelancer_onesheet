class WrapSheet

  attr_accessor :params

  def initialize(request)
    @params = request.params
  end

  def content

    body_text = "Producer Wrap Sheet"
    params.each { |key, value| body_text = body_text + "<br>#{key}: #{value}<br>" }

    {
      subject: "Wrap | #{params["Project"]} | #{params["Producer"]}",
      body: body_text
    }

  end


end
