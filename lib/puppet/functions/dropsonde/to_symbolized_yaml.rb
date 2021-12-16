# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as symbolized YAML
#   Each key is converted to a symbol to match the config file
#   format of the GLI framework.
#
# @example How to output YAML
#   # output yaml to a file
#     file { '/tmp/my.yaml':
#       ensure  => file,
#       content => dropsonde::to_symbolized_yaml($myhash),
#     }
# @example Use options control the output format
#   file { '/tmp/my.yaml':
#     ensure  => file,
#     content => drospnde::to_symbolized_yaml($myhash, {indentation: 4})
#   }
Puppet::Functions.create_function(:'dropsonde::to_symbolized_yaml') do
  # @param data
  # @param options
  #
  # @return [String]
  dispatch :to_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_yaml(data, options = {})
    config = data.map { |k, v| [k.to_sym, v] }.to_h
    config.to_yaml(options)
  end
end
