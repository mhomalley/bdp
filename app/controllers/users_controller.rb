class UsersController < ApplicationController

  layout 'admin' #, :except => [:login]

  def secure?
    #debugger
    if (action_name == 'login') #or (action_name == 'do_login')
      false
    else
      true
    end
  end
  hide_action :secure?

  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  #MHOdef show
  #  @user = User.find(params[:id])
  #  respond_to do |format|
  #    format.html # show.rhtml
  #    format.xml  { render :xml => @user.to_xml }
  #  end
  #end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit #MHO REady for Rails 2
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    if params[:user][:password].strip != params[:confirm_password].strip
      respond_to do |format|
        flash[:error] = "The passwords do not match"
        format.html { render :action => 'edit' }
        format.xml { render :xml => @user.to_xml }
      end
    end

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to admin_users_path }
        format.xml  { head :created, :location => admin_user_path(@user) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    if params[:user][:password].strip != params[:confirm_password].strip
      respond_to do |format|
        flash[:error] = "The passwords do not patch"
        format.html { render :action => 'edit' }
        format.xml { render :xml => @user.to_xml }
      end
    end
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to admin_users_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.xml  { head :ok }
    end
  end

  def logout
    #debugger
    session['user_name'] = nil
    redirect_to(login_admin_users_path)
  end

  def login
    #debugger
    session['user_name'] = nil
    @user = User.new
  end

  def do_login
    #debugger
    redirect_to(empty_admin_path)
  end
end
