class UsersController < ApplicationController
	
	before_filter :authorize, :except => [:new, :create]
  


  # GET /users/1
  # GET /users/1.xml
  def show
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
	  @notes = Note.find(:all, :conditions => ["user_id = ?", @user.id], :order => "date DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user ; @courses ; @notes }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html { render :layout => 'sessions'}
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
  end
  

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
      	flash[:notice] = "User #{@user.acc} was successfully created."
        format.html { redirect_to(login_path, :notice => 'User was successfully created. Please login!') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
      	flash[:notice] = "User #{@user.acc} was successfully updated."
        format.html { redirect_to(@user, :notice => 'User information was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = current_user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(login_path) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def authorize
  	unless User.find_by_id(session[:user_id])
  		flash[:notice] = "Please log in"
  		redirect_to :controller => :sessions, :action => :create
  	end
  end
  
end
