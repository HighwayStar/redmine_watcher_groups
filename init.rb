require 'redmine' 

Rails.logger.info 'Starting Watcher Groups plugin for Redmine'
 
Redmine::Plugin.register :redmine_watcher_groups do
  name 'Redmine Watcher Groups plugin'
  author 'Kamen Ferdinandov, Massimo Rossello'
  description 'This is a plugin for Redmine to add watcher groups functionality'
  version '1.1.0'
  url 'http://github.com/maxrossello/redmine_watcher_groups'
  author_url 'http://github.com/maxrossello'
end
