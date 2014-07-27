# encoding: UTF-8

module Puppet::Parser::Functions
  newfunction(:gethostbyname, :type => :rvalue) do |args|

    require 'ipaddr'
    require 'socket'

    name = args[0]

    hostent = Socket.gethostbyname(name)

    result = { 'name' => hostent[0], 'aliases' => hostent[1] }

    result['address'] = IPAddr.new_ntoh(hostent[3]).to_s

    result
  end
end
