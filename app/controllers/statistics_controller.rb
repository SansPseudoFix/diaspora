#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class StatisticsController < ApplicationController

  respond_to :html
  
  def statistics
    respond_to do |format|
      format.all { @css_framework = :bootstrap; render :template=>'publics/statistics', :layout => "application"}
    end
  end
  
end
