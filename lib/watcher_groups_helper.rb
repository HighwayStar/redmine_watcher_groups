# encoding: utf-8

module WatcherGroupsHelper

  # Returns the css class used to identify watch links for a given +object+
  def watcher_group_css(object)
    "#{object.class.to_s.underscore}-#{object.id}-watcher_group"
  end

  # Displays a link to gruop's account page if active
  def link_to_group(group, options={})
    if group.is_a?(Group)
      name = h(group.name)
      name
    else
      h(group.to_s)
    end
  end

  def groups_for_new_issue_watchers(issue)
    watcher_groups = issue.watcher_groups.select{|u| u.status == User::STATUS_ACTIVE}
    groups = !@project.nil? ? Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", @project.id).distinct.sort : []
    if issue.project.users.count <= 20
      watcher_groups = (watcher_groups + groups).uniq
    end
    watcher_groups
  end

  # Returns a comma separated list of users watching the given object
  def watcher_groups_list(object)
    remove_allowed = User.current.allowed_to?("delete_#{object.class.name.underscore}_watchers".to_sym, object.project)
    content = ''.html_safe
    
    lis = object.watcher_groups.collect do |group|
      s = ''.html_safe
      s << link_to_group(group, :class => 'group')
      if remove_allowed
        url = {:controller => 'watcher_groups',
               :action => 'destroy',
               :object_type => object.class.to_s.underscore,
               :object_id => object.id,
               :group_id => group}
        s << ' '  
        s << link_to(l(:button_delete), url,
          :remote => true, :method => 'delete',
          :class => "delete icon-only icon-del",
          :title => l(:button_delete))
      end
      content << content_tag('li', s)
    end
    content.present? ? content_tag('ul', content) : content
  end

  def watcher_groups_checkboxes(object, groups, checked=nil)
    groups.map do |group|
      
      c = checked.nil? ? object.watched_by_group?(group) : checked
      tag = check_box_tag 'issue[watcher_group_ids][]', group.id, c, :id => nil
      content_tag 'label', "#{tag} #{h(group)}".html_safe,
                  :id => "issue_watcher_group_ids_#{group.id}",
                  :class => "floating"
    end.join.html_safe
  end
end


unless WatcherGroupsHelper.included_modules.include?(WatchersHelper)
  WatcherGroupsHelper.send(:include, WatchersHelper)
end