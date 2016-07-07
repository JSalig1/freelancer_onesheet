require 'sinatra'
require 'sinatra/flash'
require 'mail'
require 'dotenv'
require './lib/mailer'
require './lib/email'

Dotenv.load

enable :sessions
set :session_secret, ENV['SECRET']

get "#{ENV['SUB_DIR']}/" do
  erb :new
end

post "#{ENV['SUB_DIR']}/freelancers" do
  email = Email.new(request)
  mailer = Mailer.new
  mailer.send(email)
  flash[:notice] = "Info Submitted. Thanks!"
  redirect "#{ENV['SUB_DIR']}/"
end
