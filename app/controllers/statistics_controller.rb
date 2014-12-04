#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
 
class StatisticsController < ApplicationController
 
  respond_to :html
 
  def statistics
   @as_name = self.as_name(self.datas)
   @as_network = self.as_network(self.datas)
   @as_users = self.as_users(self.datas)
   @as_active_users = self.as_active_users(self.datas)
   @as_monthly_users = self.as_monthly_users(self.datas)
   @as_posts = self.as_posts(self.datas)
   @as_comments = self.as_comments(self.datas)
   @as_version = self.as_version(self.datas)
   @as_registrations = self.as_registrations(self.datas)
   @as_services = self.as_services(self.datas)
   respond_to do |format|
    format.all { @css_framework = :bootstrap; render :template=>'publics/statistics', :layout => "application"}
   end
  end
  
  def as_name(result)
   "Name: #{result['name']}"
  end

  def as_network(result)
   "Network: #{result['network']}"
  end

  def as_users(result)
   "Total users: #{result['total_users']}"
  end

  def as_active_users(result)
  	"Active Users Half Year: #{result['active_users_halfyear']}"
  end

  def as_monthly_users(result)
  	"Active Users Monthly: #{result['active_users_monthly']}"
  end

  def as_posts(result)
  	"Local posts: #{result['local_posts']}"
  end

  def as_comments(result)
    "Local comments: #{result['local_comments']}"
  end  
  
  def as_version(result)
    "Version: #{result['version']}" 	
  end 
   
  def as_registrations(result)
   	"Registrations open: #{result['registrations_open']}"
  end 
  
  def as_services(result)
   "Services: #{result['services']}"
  end
 
  def datas
   result = {
    'name' => AppConfig.settings.pod_name,
    'network' => "Diaspora",
    'version' => AppConfig.version_string,
    'registrations_open' => AppConfig.settings.enable_registrations,
    'services' => []
   }
   
   if AppConfig.privacy.statistics.user_counts?
     result['total_users'] = User.count
     result['active_users_halfyear'] = User.halfyear_actives.count
     result['active_users_monthly'] = User.monthly_actives.count
   end
   
   if AppConfig.privacy.statistics.post_counts?
    result['local_posts'] = self.local_posts
   end
   
   if AppConfig.privacy.statistics.comment_counts?
    result['local_comments'] = self.local_comments
   end
   #   @@result["services"] = Configuration::KNOWN_SERVICES.select {|service| AppConfig["services.#{service}.enable"]}.map(&:to_s)
   #   Configuration::KNOWN_SERVICES.each do |service, options|
   #     @@result[service.to_s] = AppConfig["services.#{service}.enable"]
   #   end
   result
  end
 
  def local_posts
   Post.where(:type => "StatusMessage").joins(:author).where("owner_id IS NOT null").count
  end
  def local_comments
   Comment.joins(:author).where("owner_id IS NOT null").count
  end
 
end
