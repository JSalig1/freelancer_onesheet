require 'sinatra'
require 'sinatra/flash'
require 'mail'
require 'dotenv'
require 'icalendar'
require './lib/mailer'
require './lib/email'
require './lib/credential'

Dotenv.load

enable :sessions
set :session_secret, ENV['SECRET']

get "#{ENV['SUB_DIR']}/" do
  erb :new
end

post "#{ENV['SUB_DIR']}/freelancers" do
  email = Email.new(request)
  mailer = Mailer.new
  mailer.compose(email)
  flash[:notice] = "Info Submitted. Thanks!"
  redirect "#{ENV['SUB_DIR']}/"
end
