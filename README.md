Setup Steps
===========
In order to install the application please follow the next steps: 

~~~bash
  $ git clone git@github.com:mytriptocuba/travel_demo.git
  $ cd travel_demo
  $ bundle install
  $ rake db:create
  $ rake db:migrate
  $ rake db:seed
  $ rake spree_travel_core:load
  $ rake spree_travel_hotel:load
  $ rake spree_travel_flight:load
  $ rake trip:load:all
  $ rake trip:sample:all
~~~
