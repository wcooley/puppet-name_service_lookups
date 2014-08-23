name_service_lookups
====================

[![Build
Status](https://travis-ci.org/wcooley/puppet-name_service_lookups.png?branch=master)](https://travis-ci.org/wcooley/puppet-name_service_lookups)

This module is a collection of Puppet functions for system database (NSS) lookups,
of the `get*by*` type.

Included databases:
 * passwd
 * group
 * hosts
 * services

getpwnam
--------
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

- *Type*: rvalue

getpwuid
--------
Looks up a user by UID. See `getpwuid(3)`.

Given a user ID as parameter, it returns a hash with the keys:
  * name
  * passwd
  * uid
  * gid
  * gecos
  * dir
  * shell

  Returns *undef* is no such user ID exists.

*Example:*

    getpwuid(0)

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

- *Type*: rvalue

getgrgid
--------
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

- *Type*: rvalue

getgrnam
--------
Looks up a group by name. See `getgrnam(3)`.

Given a group name as parameter, it returns a hash with keys:
 * name - The name of the group.
 * passwd - A hashed group password (usually only '*').
 * gid - Group ID (GID).
 * mem - An array of the names of users who are members of the group.

Returns *undef* if no such group exists.

*Example:*

    getgrnam('root')

Would return (approximately):

    {
        'name': 'root',
        'passwd': '*',
        'gid': 0,
        'mem': ['root']
    }

- *Type*: rvalue

gethostbyaddr
-------------
Looks up a host by address. See `gethostbyaddr(3)`.

Given an IP address as parameter, it returns a hash with keys:
  * name - The host name.
  * aliases - An array of aliases for the host name.
  * address - The address of the host.

*Example:*

    gethostbyaddr('127.0.0.1')

Would return (approximately):

    {
        'name': 'localhost'
        'aliases': ["1.0.0.127.in-addr.arpa"]
        'address': '127.0.0.1'
    }

- *Type*: rvalue

gethostbyname
-------------
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

- *Type*: rvalue

getservbyname
-------------
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

- *Type*: rvalue

getservbyport
-------------
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

- *Type*: rvalue


Author
-------

Wil Cooley wcooley(at)nakedape.cc

Support
-------

Please log tickets and issues at our [Projects
site](https://github.com/wcooley/puppet-name_service_lookups).

License
-------
    Author:: Wil Cooley (wcooley(at)nakedape.cc)
    Copyright:: Copyright (c) 2013 Wil Cooley
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
