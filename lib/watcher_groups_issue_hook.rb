#encoding: utf-8
module WatcherGroupsIssueHook
  class WatcherGroupsIssueAfterSaveHooks < Redmine::Hook::ViewListener
    # Context:
    # * :issue => Issue being saved
    # * :params => HTML parameters
    #

    def controller_issues_new_after_save(context={})
      if "watcher_group_ids".in? context[:params][:issue]
        context[:issue].watcher_group_ids = context[:params][:issue]["watcher_group_ids"]
        context[:issue].save
        context[:issue].reload

        notes = []
        group_ids = context[:params][:issue]["watcher_group_ids"]
        group_ids.each do |group_id|
          unless group_id.blank?
            group_users = Group.find(group_id.to_i).users.uniq
            group_users.each do |user|
              notes.append("Watcher #{user.name} was added")
            end
          end
        end

        if notes.any? and Redmine::Plugin.installed? :redmine_advanced_issue_history
          add_system_journal(notes, context[:issue])
        end
      end

    end
  end
end

unless Issue.included_modules.include?(WatcherGroupsIssuePatch)
  Issue.send(:include, WatcherGroupsIssuePatch)
end