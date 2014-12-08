#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
 
class StatisticsController < ApplicationController
 
  respond_to :html
 
  def statistics
   self.datas
   @as_name = @@result['name']
   @as_network = @@result['network']
   @as_users = @@result['total_users']
   @as_active_users = @@esult['active_users_halfyear']
   @as_monthly_users =  @@result['active_users_monthly']
   @as_posts = @@result['local_posts']
   @as_comments = @@result['local_comments']
   @as_version = @@result['version']
   @as_registrations = @@result['registrations_open']
   @as_services = @@result['services']
   respond_to do |format|
    format.all { @css_framework = :bootstrap; render :template=>'publics/statistics', :layout => "application"}
   end
  end

  def datas
   @@result = {
    'name' => AppConfig.settings.pod_name,
    'network' => "Diaspora",
    'version' => AppConfig.version_string,
    'registrations_open' => AppConfig.settings.enable_registrations,
    'services' => []
   }
   
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
   end
   #   @@result["services"] = Configuration::KNOWN_SERVICES.select {|service| AppConfig["services.#{service}.enable"]}.map(&:to_s)
   #   Configuration::KNOWN_SERVICES.each do |service, options|
   #     @@result[service.to_s] = AppConfig["services.#{service}.enable"]
   #   end
   @@result
  end
 
  def local_posts
   Post.where(:type => "StatusMessage").joins(:author).where("owner_id IS NOT null").count
  end
  def local_comments
   Comment.joins(:author).where("owner_id IS NOT null").count
  end
 
end
