# encoding: UTF-8

require 'etc'

module Puppet::Parser::Functions
  newfunction(:getpwnam, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a user by name. See `getpwnam(3)`.

Given a username as parameter, it returns a hash with the keys:
  * name
  * passwd
  * uid
  * gid
  * gecos
  * dir
  * shell

  Returns *undef* is no such username exists.

*Example:*

  getpwnam('root')

Would return (approximately):
  {
    'name':     'root',
    'passwd':   '*',
    'uid':      0,
    'gid':      0,
    'gecos':    'root',
    'dir':      '/root',
    'shell':    '/bin/bash'
  }
EOS
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
