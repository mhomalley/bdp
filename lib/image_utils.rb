#convert non word characters to '-'
def headline_to_url(string)
  if string.nil?
    "No-Headline"
  else
    string.gsub(/([^a-zA-Z0-9_.-]+)/n, '-')
  end
end
  

#Upload a photo file to the appropriate place
def image_fs_path(issue, basename)
  dir_path = "#{RAILS_ROOT}/public/photos/#{@issue.date.strftime('%m-%d-%y')}"
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  "#{dir_path}/#{basename}"
end

#Upload a PDF file to the appropriate place
def pdf_fs_path(issue, basename)
  #debugger
  dir_path = "#{RAILS_ROOT}/public/pdfs"
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  "#{dir_path}/#{basename}"
end

#Upload an Editorial Cartoon to the appropriate place
def ed_cart_fs_path(issue, basename)
  dir_path = "#{RAILS_ROOT}/public/cartoons"
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  ##MHO not yet "#{dir_path}/#{@issue.date.strftime('%m-%d-%y')}#{basename}"
  "#{dir_path}/#{basename}"
end

#Upload the houses files to the appropriate place
def houses_fs_path(issue, basename)
  dir_path = "#{RAILS_ROOT}/public/houses"
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  "#{dir_path}/#{basename}"
end

