ActionMailer::Base.smtp_settings = {  
    :address              => "smtp.gmail.com",  
    :port                 => 587,  
    :domain               => "uniusa.org",  
    :user_name            => "rulebook-do-not-reply@uniusa.org",
    :password             => "Z&arP5Ua^OZxXwg09DLv",  
    :authentication       => "plain",  
    :enable_starttls_auto => true  
}  
ActionMailer::Base.default :from => 'rulebook-do-not-reply@uniusa.org'

ActionMailer::Base.default_url_options[:host] = "usarulebook2012.herokuapp.com"
