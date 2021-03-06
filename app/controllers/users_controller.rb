class UsersController < ApplicationController
	
	def new
		@user = User.new
	end
	
	def create
		@user = User.new(params[:user])
		respond_to do |format|
		  if @user.save
			sign_in @user
			format.html { redirect_to @user, notice: 'User was successfully created.' }
			format.json { render json: @user, status: :created, location: @user }
		  else
			format.html { render action: "new" }
			format.json { render json: @user.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def show
    	@user = User.find(params[:id])
    	
    	respond_to do |format|
    		format.html
    		format.json {render json: @user}
    	end
    end
	
	def index
		@users = User.all
	end
	
	
end