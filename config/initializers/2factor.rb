# Be sure to restart your server when you modify this file.

Rails.application.config.otp_api_url = "https://2factor.in/API/V1/#{ENV['OTP_API_KEY']}/SMS/"
