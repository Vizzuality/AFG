class AuthorizationsController < ApplicationController
  
  before_filter :admin_authenticated, :if => Proc.new{ AdminPassword.count > 0 }
  
  def index
    @admin_password = AdminPassword.first || AdminPassword.new
  end

  def create_or_update
    @admin_password = AdminPassword.first || AdminPassword.new
    @admin_password.password = params[:admin_password][:password]
    if @admin_password.save
      flash[:notice] = 'Password set successfully'
      redirect_to '/'
    else
      render :action => 'index'
    end
  end

end
