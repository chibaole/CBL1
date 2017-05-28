class PasswordStrategy < ::Warden::Strategies::Base
  def valid?
    return false if request.get?
    !(user_data['name'].blank? || user_data['password'].blank?)
  end

  def authenticate!
    user = User.find_by_name(user_data['name'])
    if user.nil? || user.password != user_data['password']
      fail! message: 'strategies.password.failed'
    else
      success! user
    end
  end

  private
  def user_data
    params.fetch('user', {})
  end
end
