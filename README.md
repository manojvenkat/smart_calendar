Smart Calendar Application:

Features: 

- User sign-up, login.
- Create calendar events, see them in the profile page.
- See other users' events.
- Analytics on the number of the events per day for all users.


Steps to set-up locally:

- bundle
- rake db:migrate
- rake assets:precompile
- bin/delayed_job start
- rails s -b 0.0.0.0 -p 3000