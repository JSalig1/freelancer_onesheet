require 'sinatra'
require 'sinatra/flash'
require 'mail'
require 'dotenv'
require 'icalendar'
require 'datadog/statsd'
require 'net/ldap'
require './lib/mailer'
require './lib/email'
require './lib/wrap_sheet'
require './lib/credential'
require './lib/active_directory_connection'
require './lib/active_directory_user'

Dotenv.load

enable :sessions
set :session_secret, ENV['SECRET']

# # Create a stats instance.
statsd = Datadog::Statsd.new('localhost', 8125)

get "#{ENV['SUB_DIR']}/" do
  statsd.increment('freelancer.pages.views')
  erb :new
end

get "#{ENV['SUB_DIR']}/wrap-sheet" do
  erb :wrap_sheet
end

post "#{ENV['SUB_DIR']}/freelancers" do
  credentials = Credential.new(request)
  ad_user = ActiveDirectoryUser.new(credentials)
  active_directory = ActiveDirectoryConnection.new
  account_status = active_directory.add_user(ad_user)
  email = Email.new(request)
  mailer = Mailer.new
  mailer.compose(email)
  flash[:notice] = "Info Submitted. " + account_status
  redirect "#{ENV['SUB_DIR']}/"
end

post "#{ENV['SUB_DIR']}/wrap-sheet" do
  wrap_sheet = WrapSheet.new(request)
  mailer = Mailer.new
  mailer.send_out(wrap_sheet.content)
  flash[:notice] = "Info Submitted."
  redirect "#{ENV['SUB_DIR']}/wrap-sheet"
end
