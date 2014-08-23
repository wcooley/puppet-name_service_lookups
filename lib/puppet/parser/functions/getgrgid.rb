# encoding: UTF-8

require 'etc'

module Puppet::Parser::Functions
  newfunction(:getgrgid, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a group by GID. See `getgrgid(3)`.

Given a GID as parameter, it returns a hash with keys:
  * name - The name of the group.
  * passwd - A hashed group password (usually only '*').
  * gid - Group ID (GID).
  * mem - An array of the names of users who are members of the group.

Returns *undef* if no such group ID exists.

*Example:*

    getgrgid(0)

Would result in (approximately):

    {
      'name': 'root',
      'passwd': '*',
      'gid': 0,
      'mem': ['root']
    }

    EOS

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

