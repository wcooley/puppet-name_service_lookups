# encoding: UTF-8

require 'etc'

module Puppet::Parser::Functions
  newfunction(:getgrnam, :type => :rvalue) do |args|
    grp = args[0]

    begin
      grent = Etc.getgrnam(grp)
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

    result
  end
end
