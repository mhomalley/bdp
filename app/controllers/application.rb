# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #Rails 2.0? session :session_key => '_bdp_session_id'
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7c3476054bb64b71d44488e193190783'

  #MHO Why is this needed?
  before_filter :set_charset

  before_filter :authenticate

  def authenticate
    #debugger
    unless secure?
      return true
    end

    if session['user_name'] == 'try'
      #debugger
      #session['user_name'] = nil
      #redirect_to(login_admin_users_path)
      #return false
    end

    if session['user_name'] != nil
      return true
    end

    if user == nil or not user.authenticate(params['user_name'], params['password'])
      flash[:error] = 'Either the user name or password is incorrect.'
      redirect_to(:controller => 'users', :action => 'login')
      false
    else
      session['user_name'] = user.user_name
      true
    end 
  end

  #All controllers are secure except the ones that are specifically marked as not secure
  def secure?
    #debugger
    true
  end

  def set_charset
    ActiveRecord::Base.connection.execute("SET CHARSET latin1")
  end

  def user
    if @user == nil
      user_name = session['user_name']
      if user_name == nil
        user_name = params['user_name']
      end
      @user = User.find_by_user_name(user_name)
    end
    @user
  end
end
