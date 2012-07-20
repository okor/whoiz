About WhoIz
===========

WhoIz is a simple WHOIS lookup application. It's built on Sinatra and Heroku friendly.


Use It
======

JSON

    curl http://whoiz.herokuapp.com/lookup.json?url=yahoo.com

Browser 
    
    http://whoiz.herokuapp.com
    http://whoiz.herokuapp.com/lookup?url=yahoo.com


Clone It
========
    git clone git://github.com/okor/whoiz.git


Restrict It
===========

Edit

    main.rb

Change this

    before do
      response['Access-Control-Allow-Origin'] = '*'
    end

To this

    before do
      response['Access-Control-Allow-Origin'] = 'http://yourwebsite.com'
    end


Deploy It
=========
    heroku create
    git push heroku master
    heroku open


