#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
 
class StatisticsController < ApplicationController
 
  @@result = {
    'name' => AppConfig.settings.pod_name,
    'network' => "Diaspora",
    'version' => AppConfig.version_string,
    'registrations_open' => AppConfig.settings.enable_registrations,
    'services' => []
  }
 
  respond_to :html
 
  def statistics
    _statistics
    @as_html = self.as_html
    respond_to do |format|
      format.all { @css_framework = :bootstrap; render :template=>'publics/statistics', :layout => "application"}
    end
  end
 
  def as_html
    "t('Name'): #{@@result['name']}
   Network: #{@@result['network']}
   Total users: #{@@result['total_users']}
   Active Users Half Year: #{@@result['active_users_halfyear']}
   Active Users Monthly: #{@@result['active_users_monthly']}
   Local posts: #{@@result['local_posts']}
   Local comments: #{@@result['local_comments']}
   Version: #{@@result['version']}
   Registrations open: #{@@result['registrations_open']}
   Services: #{@@result['services']}
   "
  end
 
  def _statistics
    if AppConfig.privacy.statistics.user_counts?
      @@result['total_users'] = User.count
      @@result['active_users_halfyear'] = User.halfyear_actives.count
      @@result['active_users_monthly'] = User.monthly_actives.count
    end
    if AppConfig.privacy.statistics.post_counts?
      @@result['local_posts'] = self.local_posts
    end
    if AppConfig.privacy.statistics.comment_counts?
      @@result['local_comments'] = self.local_comments
    # end
    #   @@result["services"] = Configuration::KNOWN_SERVICES.select {|service| AppConfig["services.#{service}.enable"]}.map(&:to_s)
    #   Configuration::KNOWN_SERVICES.each do |service, options|
    #     @@result[service.to_s] = AppConfig["services.#{service}.enable"]
    end
  end
 
  def local_posts
    Post.where(:type => "StatusMessage").joins(:author).where("owner_id IS NOT null").count
  end
  def local_comments
    Comment.joins(:author).where("owner_id IS NOT null").count
  end
 
end
