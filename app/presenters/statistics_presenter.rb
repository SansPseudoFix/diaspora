class StatisticsPresenter

  def as_json(options={})
    result = raw_data
    result["services"] = Configuration::KNOWN_SERVICES.select {
      |service| AppConfig["services.#{service}.enable"]}.map(&:to_s)
    result = result.merge(services_as_map(false))

    result
  end
  
  def as_simple_map
    result = raw_data
    if result['registrations_open']
      result['registrations_open'] = I18n.t('statistics.opened')
    else
      result['registrations_open'] = I18n.t('statistics.closed')
    end
    
    result
  end
  
  def raw_data
    result = {
      'name' => AppConfig.settings.pod_name,
      'network' => "Diaspora",
      'version' => AppConfig.version_string,
      'registrations_open' => AppConfig.settings.enable_registrations
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
    
    result
  end
  
  def services_as_map(for_html)
    result = {}
    Configuration::KNOWN_SERVICES.each do |service, options|
      enabled = AppConfig["services.#{service}.enable"]
      if for_html
	result[service.to_s] = enabled ? I18n.t('statistics.enabled') : I18n.t('statistics.disabled')
      else
	result[service.to_s] = enabled
      end
    end
    
    result
  end
  
  def local_posts
    Post.where(:type => "StatusMessage").joins(:author).where("owner_id IS NOT null").count
  end

  def local_comments
    Comment.joins(:author).where("owner_id IS NOT null").count
  end
end
