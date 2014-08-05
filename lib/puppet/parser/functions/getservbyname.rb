# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyname, :type => :rvalue) do |args|

    serv = args[0]
    proto = args[1]

    result = Socket.getservbyname(serv, proto)

    result
  end
end
