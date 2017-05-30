module Admin
  class SessionsController < AdminController
  	skip_before_action :authenticate_user!

    layout 'plain'

  	def new

	  end

	  def create
	    authenticate_user!
	    redirect_to '/admin'
	  end

	  def destroy
	    warden.logout
	    redirect_to new_admin_sessions_url
	  end
  end
end
