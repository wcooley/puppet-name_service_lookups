# encoding: UTF-8

require 'socket'

module Puppet::Parser::Functions
  newfunction(:getservbyport, :type => :rvalue) do |args|

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

