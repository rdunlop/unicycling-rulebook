ActionMailer::Base.smtp_settings = {  
    :address              => "smtp.gmail.com",  
    :port                 => 587,  
    :domain               => "dunlopweb.com",  
    :user_name            => "robin@dunlopweb.com",  
    :password             => "prilupoetfodhmza",  
    :authentication       => "plain",  
    :enable_starttls_auto => true  
}  

ActionMailer::Base.default_url_options[:host] = "young-lake-8637.herokuapp.com"
