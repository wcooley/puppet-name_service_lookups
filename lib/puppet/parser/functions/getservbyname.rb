# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyname, :type => :rvalue) do |args|

    result = Socket.getservbyname(*args)

    result
  end
end
