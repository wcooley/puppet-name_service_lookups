module Puppet::Parser::Functions
  newfunction(:gethostbyaddr, :type => :rvalue) do |args|

    require 'ipaddr'
    require 'socket'

    address = IPAddr.new(args[0])

    hostent = Socket.gethostbyaddr(address.hton)

    result = { 'name' => hostent[0], 'aliases' => hostent[1] }

    result['address'] = IPAddr.new_ntoh(hostent[3]).to_s

    result
  end
end
