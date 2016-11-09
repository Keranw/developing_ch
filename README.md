# Curiosity Hunter Backend

To run the backend on MacOS, the system administrator needs to set up Ruby on Rails environment first, then run the database system, run the application at last.  

## Ruby on Rails environment on MacOS
To build up RoR environment, we need to set up the Homebrew as the installer:
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
and necessary package (libxml2, libxslt, libicon, wget, gpg2) with commmand:
```
$ brew install package_name 
```
Then, install RVM for Ruby. (Users also need to restart Terminal after RVM installed)
```
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ curl -sSL https://get.rvm.io | bash -s stable

```
Finally, install Ruby 2.3.0:
```
$ rvm requirements
$ rvm install 2.3.0
```
and Rails 5.0.0.1:
```
$ gem install bundler​
$ gem install rails
```
## Database System
In this project, we use PostgreSQL (v9.5) as the database system. Users just need to download system package and copy to MacOS application folder. 

## Run Application

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```
Next, migrate the database:

```
$ rails db:migrate
```
Finally, it is ready to run the app in a local server:
```
$ rails server
```

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).