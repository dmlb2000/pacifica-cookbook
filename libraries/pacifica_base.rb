# This is the primary shared library for Pacifica custom resources
module PacificaCookbook
  require_relative 'helpers_base'
  require_relative 'helpers_base_dir'
  # Pacifica base class with common properties and actions
  class PacificaBase < Chef::Resource
    include PacificaHelpers::BaseDirectories
    property :name, String, name_property: true
    property :service_name, String, default: lazy { "#{name}-#{resource_name.to_s.tr('_', '-')}" }
    property :script_name, String, default: lazy { service_name }
    property :config_name, String, default: lazy { "#{service_name}.ini" }
    property :cpconfig_name, String, default: lazy { "#{service_name}-cp.ini" }
    property :command_name, String, default: 'Server.py'
    property :prefix, String, default: '/opt'
    property :directory_opts, Hash, default: {}
    property :virtualenv_opts, Hash, default: {}
    property :python_opts, Hash, default: { version: '2.7' }
    property :pip_install_opts, Hash, default: {}
    property :script_opts, Hash, default: {}
    property :config_opts, Hash, default: {}
    property :cpconfig_opts, Hash, default: {}
    property :git_client_opts, Hash, default: {}
    property :service_opts, Hash, default: lazy {
      {
        directory: prefix_dir,
      }
    }
    property :port, Integer, default: 8080
    property :run_command, String, default: lazy {
      "#{prefix_dir}/bin/#{command_name} --port #{port}"
    }
    property :service_actions, Array, default: [:enable, :start]
    property :service_disabled, [TrueClass, FalseClass], default: false
    default_action :create
    action :create do
      extend PacificaCookbook::PacificaHelpers::Base
      include_recipe 'chef-sugar'
      base_packages
      base_directory_resources
      base_git_client
      base_python_runtime
      base_python_virtualenv
      base_python_execute_requirements
      base_file
      base_config
      base_cpconfig
      base_poise_service
      base_service
    end
  end
end
