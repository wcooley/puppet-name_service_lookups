# encoding: UTF-8

require 'etc'

module Puppet::Parser::Functions
  newfunction(:getgrgid, :type => :rvalue) do |args|
    gid = Integer(args[0])
    begin
      grent = Etc.getgrgid(gid)
      grvals = grent.values[0..3]
      grkeys = grent.members[0..3].collect { |k| k.to_s }
      result = Hash[grkeys.zip(grvals)]

    rescue ArgumentError => ae
      if ae.to_s =~ /can't find group/
        result = :undef
      else
        raise ae
      end
    end
  end
end

