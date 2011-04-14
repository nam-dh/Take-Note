class CoursesController < ApplicationController
  
  # GET /courses/1
  # GET /courses/1.xml
  
  before_filter :authorize
  def show
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    @course = current_user.course.find(params[:id])
    @notes = Note.find(:all, :conditions => ["course_id = ?", params[:id]], :order => "date DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course ; @notes }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    @course = current_user.course.find(params[:id])
  end
  

  # POST /courses
  # POST /courses.xml
  def create
    @user = current_user
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to(@course, :notice => 'Course was successfully created.') }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    @user = current_user
    @course = current_user.course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(@course, :notice => 'Course was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @user = current_user
    @course = current_user.course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(@user) }
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
