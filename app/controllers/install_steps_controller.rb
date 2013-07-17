class InstallStepsController < ApplicationController
  before_filter :signed_in_user
  include Wicked::Wizard

  prepend_before_filter :set_steps

  def show
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :choose_os
      @user.os = params[:os]
    when :choose_os_version
      @user.os_version = params[:os_version]
    end
    render_wizard @user
  end

  private
    def set_steps
      if ( params[:os] || current_user.os ) == "Mac"
        self.steps = mac_steps
      elsif ( params[:os] || current_user.os ) == "Windows"
        self.steps = windows_steps
      else
        self.steps = [:choose_operating_system]
      end
    end

    def mac_steps
      [:choose_os, :choose_mac_os_version, :railsinstaller, :update_rails, :sublime_text]
    end

    def windows_steps
      [:choose_os, :choose_win_os_version]
    end
end
