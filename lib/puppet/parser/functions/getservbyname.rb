# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyname, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a service by name. See `getservbyname(3)`.

Given a network service name (such as from `/etc/services`) and optionally a
transport protocol, it returns the associated port number. If a protocol is not
specified, the default 'tcp' is used.

Returns *undef* is no such service name exists.

*Example:*

  getservbyname('syslog', 'udp')

Would return (approximately):

  514

*Example:*

  getservbyname('syslog')

Might return:

  undef


EOS
    begin
      result = Socket.getservbyname(*args)

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
