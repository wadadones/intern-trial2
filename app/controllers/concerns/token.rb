module Token
  extend ActiveSupport::Concern

  def new_token
    SecureRandom.urlsafe_base64
  end
end
