class Credential

  attr_accessor :request, :lock, :username, :password

  def initialize(request)
    @request = request
    @lock = ENV['LOCK'].split(',')
    @username = generate_username
    @password = generate_password
  end

  private

  def generate_username
    username = request[lock[0]][lock[1].to_i] + request[lock[2]]
    username.downcase.delete(' ')
  end

  def generate_password
    password = request[lock[0]][lock[1].to_i] + request[lock[2]][lock[1].to_i]
    password.upcase + lock[3]
  end
end
