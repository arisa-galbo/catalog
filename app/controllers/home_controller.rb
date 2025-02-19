class HomeController < ApplicationController
  include AdminAuthentication
  allow_unauthenticated_admin_access only: %i[index]
  def index
  end
end
