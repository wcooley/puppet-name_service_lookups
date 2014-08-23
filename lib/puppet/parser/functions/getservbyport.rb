# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyport, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a service by port number. See `getservbyport(3)`. Note that this is
only available on Ruby 1.9 and later.

Given a network service port (such as from `/etc/services`) and optionally a
transport protocol, it returns the associated service name. If a protocol is
not specified, the default 'tcp' is used.

Returns *undef* is no such port number exists.

*Example:*

  getservbyport(514)

Would return (approximately):

  shell

*Example:*

  getservbyname(514, 'udp')

Would return:

  syslog


EOS

    args[0] = Integer(args[0])

    begin
      result = Socket.getservbyport(*args)
    rescue SocketError => se
      if se.to_s =~ %r{no such service}
        result = :undef
      else
        raise se
      end
    end

    result
  end
end

