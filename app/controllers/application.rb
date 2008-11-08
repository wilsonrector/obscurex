# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '1843ca938021b266176d199f4809f83a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  require 'digest/sha1'
  
  before_filter :require_login
  
  private
  def require_login
    unless current_user
      set_return_url
      flash[:message] = "You must be logged in to see that page!"
      redirect_to login_url
      return false
    end
  end
  
  def current_user
    @current_user ||= retrieve_current_user
  end
  helper_method :current_user
  
  def current_user=( user )
    @current_user = user
    save_current_user
  end
  
  def retrieve_current_user
    User.find( session[ :current_user ] ) if session[ :current_user ]
  end
  
  def save_current_user
    session[ :current_user ] = @current_user.nil? ? nil : @current_user.id
  end
  
  def set_return_url
    session[ :return_to ] = request.protocol + request.host_with_port +
      request.request_uri
  end
  
  def return_url
    session[ :return_to ]
  end
  
  def clear_return_url
    session[ :return_to ] = nil
  end
  
  def go_to_login_url
    redirect_to login_url
  end
  
  def go_to_return_url_or_default
    if return_url
      redirect_to return_url
      clear_return_url
    else
      redirect_to default_url
    end
  end
  
  def set_user
    User.current_user= current_user
  end
  
  def clear_user
    User.current_user= nil
  end
end
