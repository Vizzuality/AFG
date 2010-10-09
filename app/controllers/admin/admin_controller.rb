class Admin::AdminController < ApplicationController
  layout 'admin'
  
  before_filter :admin_authenticated
  
  def show    
    
  end
    
end