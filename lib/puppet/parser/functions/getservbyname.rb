# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyname, :type => :rvalue) do |args|

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
