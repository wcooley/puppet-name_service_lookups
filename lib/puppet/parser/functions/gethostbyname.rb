# encoding: UTF-8

require 'ipaddr'
require 'socket'

module Puppet::Parser::Functions
  newfunction(:gethostbyname, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a host by address. See `gethostbyname(3)`.

Given a host name as a parameter, it returns a hash with keys:
    * name - The host name.
    * aliases - An array of aliases for the host name.
    * address - The address of the host.

    Returns *undef* if no such host exists.

*Example:*

    gethostbyname('localhost')

Would return (approximately):

  {
    'name': 'localhost',
    'aliases': ['localhost.localdomain', '1.0.0.127.in-addr.arpa'],
    'address': '127.0.0.1'
  }

    EOS

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
