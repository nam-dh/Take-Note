class NotesController < ApplicationController
  layout 'users'
  before_filter :authorize

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    @notes = Note.find(:all, :conditions => ["course_id = ?", params[:id]], :order => "date")
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @user = current_user
    @courses = @user.course
    @note = Note.new
    @course = params[:course]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note ; @course ; @user }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    @course = Course.find(@note.course_id)
    @course.number = @course.number + 1
    @course.save
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    respond_to do |format|
      if @note.save
        format.html { redirect_to :controller => "courses", :action => "show", :id => @note.course_id }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to :controller => "notes", :action => "edit", :id => @note.id, :notice => 'Note was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    @course = Course.find(@note.course_id)
    @course.number = @course.number - 1
    @course.save

    respond_to do |format|
      format.html { redirect_to(user_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    @course_select_list = [['All', 0]] + Course.find(:all, :conditions => ["user_id = ?", @user.id]).collect { |x| [x.name, x.id] }
  end
  
  def result
    @user = current_user
    @courses = Course.find(:all, :conditions => ["user_id = ?", @user.id])
    f = params[:course_spec].to_i
    yfrom = params[:date]["from(1i)"].to_i
    mfrom = params[:date]["from(2i)"].to_i
    dfrom = params[:date]["from(3i)"].to_i
    yto = params[:date]["to(1i)"].to_i
    mto = params[:date]["to(2i)"].to_i
    dto = params[:date]["to(3i)"].to_i
    key = params[:key]
    query ="%"
    query << key 
    query << "%"
    if f == 0
      @notes = Note.where "user_id = ? AND date BETWEEN '?-?-?' AND '?-?-?' AND content like ?", @user.id, yfrom, mfrom, dfrom, yto, mto, dto, query
    else
      @notes = Note.where "user_id = ? AND course_id = ? AND date BETWEEN '?-?-?' AND '?-?-?' AND content like ?", @user.id, f, yfrom, mfrom, dfrom, yto, mto, dto, query
    end
    flash.now[:notice] = "Searh result"
    render 'show'
  end
  
  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice] = "Please log in"
      redirect_to :controller => :sessions, :action => :create
    end
  end


end
