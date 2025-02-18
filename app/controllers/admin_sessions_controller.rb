class AdminSessionsController < ApplicationController
    allow_unauthenticated_access only: %i[new create show destroy]
    include AdminAuthentication
    allow_unauthenticated_admin_access only: %i[new create show]
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_admin_session_url, alert: "Try again later." }
  
    def new
    end
    def show
      #テストページ表示用。ルーティング等完了後は削除
    end
  
    def create
      if admin = Admin.authenticate_by(params.permit(:email_address, :password))
        start_new_admin_session_for(admin)
        redirect_to after_admin_authentication_url
      else
        redirect_to new_admin_session_path, alert: "Invalid email or password."
      end
    end
  
    def destroy
      terminate_admin_session
      redirect_to new_admin_session_path
    end
  end