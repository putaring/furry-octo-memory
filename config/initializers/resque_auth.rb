Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_USER"] && password == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD"]
end
