OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1397561973795270', '3df56d4e9f5ab134fe6f8108311a370a'
end

