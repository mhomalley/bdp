class IssuesController < ApplicationController

  layout 'admin'

  before_filter :find_issue, :except => :new
  
  def find_issue
    #debugger
    if params.has_key?(:id)
      if params[:id] == 'latest'
        @issue = Issue.find(:first, :order => 'date DESC')
        params[:id] = d(@issue.date)
      else
        @issue = Issue.find_by_strdate(params[:id])
      end
    else
      @issue = Issue.find(:first, :order => 'date DESC')
    end
  end

  # GET /issues
  # GET /issues.xml
  def index
    #debugger
    @issues = Issue.paginate(:all, :page => params[:page], :order => 'date DESC')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @issues.to_xml }
    end
  end

  # GET /issues/1
  # GET /issues/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @issue.to_xml }
    end
  end

  # GET /issues/new
  def new
    #debugger
    @issue = Issue.new
    @issue.date = Date.today
  end

  # GET /issues/1;edit
  def edit
  end

  # GET /issues/1/upload
  def upload
    #debugger
  end

  # POST /issues/1/do_upload
  def do_upload
    #debugger
    if params[:pdf] && (fn = params[:pdf][:file_name]).to_s != ''
      #debugger
      fsfp = pdf_fs_path(@issue, fn.original_filename())
      File.open(fsfp, 'wb') do |f|
        f.write(fn.read)
      end
      flash[:notice] = "Update done: #{params[:commit]}, File:#{fsfp}"
    elsif params[:houses] && (fn = params[:houses][:file_name]) && fn.to_s != ''
      #debugger
      fsfp = houses_fs_path(@issue, fn.original_filename())
      File.open(fsfp, 'wb') do |f|
        f.write(fn.read)
      end
      flash[:notice] = "Update done: #{params[:commit]}, File:#{fsfp}"
   elsif params[:ed_cart] && (fn = params[:ed_cart][:file_name]) && fn.to_s != ''
      #debugger
      fsfp = ed_cart_fs_path(@issue, fn.original_filename())
      File.open(fsfp, 'wb') do |f|
        f.write(fn.read)
      end
      flash[:notice] = "Update done: #{params[:commit]}, File:#{fsfp}"
    else
      flash[:notice] = "No Update File Specified: #{params[:commit]}"
    end

    redirect_to upload_admin_issue_path(:id => d(@issue.date))
  end
  
  def kill_feeds
    #debugger
    cache_dir = ActionController::Base.page_cache_directory
    cache_dir = cache_dir + '/feeds/*'
    FileUtils.rm_r(Dir.glob(cache_dir))
  end

  # GET /issues/1/kill_cache
  def kill_cache
    #debugger
    kill_feeds()
    cache_dir = ActionController::Base.page_cache_directory
    cache_dir = cache_dir + '/issue/*'
    FileUtils.rm_r(Dir.glob(cache_dir))
    flash[:notice] = "Caches were successfully removed from #{cache_dir}"
    redirect_to new_admin_issue_article_path(:issue_id => d(@issue.date))
  end

  # GET /issues/1/kill_issue_cache
  def kill_issue_cache
    #debugger
    kill_feeds()
    cache_dir = ActionController::Base.page_cache_directory
    cache_dir = cache_dir + "/issue/#{d(@issue.date)}*"
    FileUtils.rm_r(Dir.glob(cache_dir))
    flash[:notice] = "Caches were successfully removed from #{cache_dir}"
    redirect_to new_admin_issue_article_path(:issue_id => d(@issue.date))
  end

  # POST /issues
  # POST /issues.xml
  def create
    #debugger
    params[:issue][:date] = params[:issue]['date(2i)'] + '-' + params[:issue]['date(3i)'] + '-' + params[:issue]['date(1i)']
    #debugger
    params[:issue][:date] = Date.strptime(params[:issue][:date], '%m-%d-%Y')
    #debugger
    @issue = Issue.new(params[:issue])
    respond_to do |format|
      if @issue.save
        flash[:notice] = 'Issue was successfully created.'
        #MHO having created, go to issue_articles to fill in articles
        format.html { redirect_to new_admin_issue_article_path(:issue_id => d(@issue.date)) }
        format.xml  { head :created, :location => issue_path(@issue) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @issue.errors.to_xml }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.xml
  def update
    #debugger
    params[:issue][:date] = params[:issue]['date(2i)'] + '-' + params[:issue]['date(3i)'] + '-' + params[:issue]['date(1i)']
    params[:issue][:date] = Date.strptime(params[:issue][:date], '%m-%d-%Y')
    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        flash[:notice] = 'Issue was successfully updated.'
        format.html { redirect_to admin_issues_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @issue.errors.to_xml }
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    #debugger
    render :action => :edit
  end

  # DELETE /issues/1
  # DELETE /issues/1.xml
  def destroy
    #debugger
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to empty_admin_path }
      #MHOformat.html { redirect_to admin_issues_path }
      format.xml  { head :ok }
    end
  end
  
  # PUBLISH /issues
  def publish
    #debugger
    PubDate.publish
    flash[:notice] = 'Issue has been published.'
    redirect_to new_admin_issue_article_path(:issue_id => d(@issue.date))
   end
end
