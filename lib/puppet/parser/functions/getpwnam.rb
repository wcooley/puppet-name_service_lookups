# encoding: UTF-8

require 'etc'

module Puppet::Parser::Functions
  newfunction(:getpwnam, :type => :rvalue) do |args|

    user = args[0]

    begin
      pwent = Etc.getpwnam(user)

      # Truncate to first 7 for consistency between platforms
      pwvals = pwent.values[0..6]

      # In Ruby 1.8, members returns strings but in 1.9 returns symbols
      pwkeys = pwent.members[0..6].collect { |k| k.to_s }

      result = Hash[pwkeys.zip(pwvals)]

    rescue ArgumentError => ae
      if ae.to_s =~ /can't find user/
       result = :undef
      else
        raise ae
      end
    end

    result
  end
end
