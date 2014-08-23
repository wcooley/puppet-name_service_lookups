# encoding: UTF-8

require 'ipaddr'
require 'socket'

module Puppet::Parser::Functions
  newfunction(:gethostbyaddr, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a host by address. See `gethostbyaddr(3)`.

Given an IP address as parameter, it returns a hash with keys:
  * name - The host name.
  * aliases - An array of aliases for the host name.
  * address - The address of the host.

*Example:*

    gethostbyaddr('127.0.0.1')

Would return (approximately):

    {
      'name': 'localhost'
      'aliases': ["1.0.0.127.in-addr.arpa"]
      'address': '127.0.0.1'
    }

    EOS

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
