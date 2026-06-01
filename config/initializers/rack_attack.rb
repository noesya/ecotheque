# Brevo IPs
Rack::Attack.safelist_ip("1.179.112.0/20")
Rack::Attack.safelist_ip("172.246.240.0/20")

# Google Bots
Rack::Attack.safelist("Google Bots UA") do |req|
  user_agent = req.user_agent.to_s.downcase
  user_agent.include?('googlebot') ||
  user_agent.include?('google-') ||
  user_agent.include?('storebot-google')
end

# Always allow requests to assets
Rack::Attack.safelist('allow assets') { |req| req.path.start_with?('/assets') }

# Limit requests by IP address
Rack::Attack.throttle("Per minute", limit: 75, period: 1.minute) { |req|
  req.ip
}
Rack::Attack.throttle("Per hour", limit: 5_000, period: 1.hour) { |req|
  req.ip
}
Rack::Attack.throttle("Per day", limit: 80_000, period: 1.day) { |req|
  req.ip
}