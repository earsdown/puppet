module Puppet::DataProviders

  def self.assert_loaded
    unless @loaded
      require 'puppet/pops'
      require 'puppet/data_providers/data_adapter'
    end
    @loaded = true
  end

  def self.lookup_in_environment(name, lookup_invocation, merge)
    assert_loaded()
    adapter = DataAdapter.adapt(Puppet.lookup(:current_environment))
    adapter.env_provider.lookup(name, lookup_invocation, merge)
  end

  MODULE_NAME = 'module_name'.freeze

  def self.lookup_in_module(name, lookup_invocation, merge)
    # Do not attempt to do a lookup in a module unless the name is qualified.
    qual_index = name.index('::')
    throw :no_such_key if qual_index.nil?
    module_name = name[0..qual_index-1]

    assert_loaded()
    adapter = DataAdapter.adapt(Puppet.lookup(:current_environment))
    data_provider = adapter.module_provider(module_name)
    throw :no_such_key if data_provider.nil?
    data_provider.lookup(name, lookup_invocation, merge)
  end
end
