ActionController::Routing::Routes.draw do |map|

  map.resources :supporters, :collection => \
  {
    :thanks => :get,
  }

  map.with_options :controller => 'feeds' do |feeds|
    feeds.formatted_feeds_action '/feeds/:action.:format', {:requirements => {:action => /\w+/}}
    feeds.feed_action '/feeds/:action', {:requirements => {:action => /\w+/}}
  end

  map.sitemap_index 'sitemap_index.xml', :controller => 'feeds', :action => 'sitemap_index', :format => 'xml'
  map.sitemap_old 'sitemap_old.xml', :controller => 'feeds', :action => 'sitemap_old', :format => 'xml'
  map.sitemap 'sitemap.xml', :controller => 'feeds', :action => 'sitemap', :format => 'xml'
  map.sitemap_news 'sitemap_news.xml', :controller => 'feeds', :action => 'sitemap_news', :format => 'xml'

  map.with_options :controller => 'public' do |public|
    # Remember to delete public/index.html.
    public.empty '', {:action => 'cur_issue'}
    public.public_archives '/issue/archives/:yr/:mo', {:action => 'archives', :yr => nil, :mo => nil, :requirements => {:yr => /\d\d/, :mo => /[01]?\d/}}

    #added :format for xml
    public.public_issue '/issue/:issue_id', {:action => 'index', :issue_id => nil, :requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/}}
    public.public_article '/issue/:issue_id/article/:storyID.:format', {:action => 'article', :requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :storyID => /\d+/}}
    public.public_article '/issue/:issue_id/article/:storyID', {:action => 'article', :requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :storyID => /\d+/}}
    public.public_action '/issue/:issue_id/:action.:format', {:requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :action => /\w+/}}
    public.public_action '/issue/:issue_id/:action', {:requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :action => /\w+/}}
    public.print_public_article '/issue/:issue_id/article/:storyID/print', {:action => 'print_article', :requirements => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :storyID => /\d+/}}
  end

  # Legacy routes from the CF system which must be preserved because of Google:
  map.with_options :controller => 'public' do |public|
    public.issue 'index.cfm', {:action => 'old_index'}
    public.article 'article.cfm', {:action => 'old_article'}
    public.contact 'contact.cfm', {:action => 'old_contact'}
    public.editorials 'editorials.cfm', {:action => 'old_editorials'}
    public.commentary 'commentary.cfm', {:action => 'old_commentary'}
    public.columns 'columns.cfm', {:action => 'old_columns'}
    public.arts_entertainment 'arts_entertainment.cfm', {:action => 'old_arts_entertainment'}

    public.text_issue '/text/index.cfm', {:action => 'old_index'}
    public.text_article '/text/article.cfm', {:action => 'old_article'}
    public.text_contact '/text/contact.cfm', {:action => 'old_contact'}
    public.text_editorials '/text/editorials.cfm', {:action => 'old_editorials'}
    public.text_commentary '/text/commentary.cfm', {:action => 'old_commentary'}
    public.text_columns '/text/columns.cfm', {:action => 'old_columns'}
    public.text_arts_entertainment '/text/arts_entertainment.cfm', {:action => 'old_arts_entertainment'}

    public.archives 'archives.cfm', {:action => 'unknown'}
  end

  ##map.connect 'classifieds/index.cfm', {:controller => 'foo', :action => ''}
  map.connect 'houses/:action', {:controller => 'houses'}
  map.connect 'houses/:action.cfm', {:controller => 'houses', :format => "cfm"}

  #quick urls
  map.connect 'ad_sizes', {:controller => 'public', :action => 'ad_sizes'}
  map.subscribe 'subscribe', {:controller => 'public', :action => 'subscribe'}
  map.fund 'fund', {:controller => 'public', :action => 'fund'}
  map.benefit 'benefit', {:controller => 'public', :action => 'benefit'}
  map.thanks 'thanks', {:controller => 'public', :action => 'thanks'}
  map.connect 'openletter', {:controller => 'public', :action => 'openletter'}

  #Admin URLs
  map.empty_admin 'admin', {:controller => 'articles', :action => 'new', :issue_id => 'latest'}
  map.kill_cache 'admin/issues/:id/kill_cache', {:controller => 'issues', :action => 'kill_cache'}
  map.kill_issue_cache 'admin/issues/:id/kill_issue_cache', {:controller => 'issues', :action => 'kill_issue_cache'}
  
  map.with_options :path_prefix => 'admin', :name_prefix => 'admin_' do |admin|
    admin.resources :users, :collection => {:login => :get, :logout => :get, :do_login => :post}
    admin.resources :issues, :member => {:publish => :get, :re_publish => :post, :upload => :get, :do_upload => :post} do |issue|
      issue.resources :articles, :member => {:add_html => :get, :create_html => :post}
      issue.resources :images
    end
  end

  #clean up all mcl routes
  map.connect '*junk', {:controller => 'public', :action => 'unknown'}
end
