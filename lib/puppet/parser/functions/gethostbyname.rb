# encoding: UTF-8

module Puppet::Parser::Functions
  newfunction(:gethostbyname, :type => :rvalue) do |args|

    require 'ipaddr'
    require 'socket'

    name = args[0]

    begin
      hostent = Socket.gethostbyname(name)
      result = { 'name' => hostent[0], 'aliases' => hostent[1] }
      result['address'] = IPAddr.new_ntoh(hostent[3]).to_s

    rescue SocketError => se
      if se.to_s =~ %r{nodename nor servname provided, or not known}
        result = :undef
      else
        raise se
      end
    end

    result
  end
end
