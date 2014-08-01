# encoding: UTF-8

require 'ipaddr'
require 'socket'

module Puppet::Parser::Functions
  newfunction(:gethostbyname, :type => :rvalue) do |args|

    name = args[0]

    begin
      hostent = Socket.gethostbyname(name)
      result = { 'name' => hostent[0], 'aliases' => hostent[1] }
      result['address'] = IPAddr.new_ntoh(hostent[3]).to_s

    rescue SocketError => se
      if se.to_s =~ %r{not known}
        result = :undef
      else
        raise se
      end
    end

    result
  end
end
