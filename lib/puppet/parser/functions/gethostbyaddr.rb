# encoding: UTF-8

require 'ipaddr'
require 'socket'

module Puppet::Parser::Functions
  newfunction(:gethostbyaddr, :type => :rvalue) do |args|

    address = IPAddr.new(args[0])

    begin
      hostent = Socket.gethostbyaddr(address.hton)
      result = { 'name' => hostent[0], 'aliases' => hostent[1] }
      result['address'] = IPAddr.new_ntoh(hostent[3]).to_s

    rescue SocketError => se
      if se.to_s == 'host not found'
        result = :undef
      else
        raise se
      end
    end

    result
  end
end
