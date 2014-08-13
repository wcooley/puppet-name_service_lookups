# encoding: UTF-8

require 'spec_helper'

describe 'getservbyname' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getservbyname') \
      .should eq 'function_getservbyname'
  end

  context 'without protocol' do
    it 'should return expected result with valid input' do
      Socket.expects(:getservbyname).with('telnet').returns(23)
      should run.with_params('telnet').and_return(23)
    end
    it 'should return undef on lookup failure' do
      Socket.expects(:getservbyname).with('smellnet')\
       .raises(SocketError, 'no such service smellnet/tcp')
      expect(subject).to run.with_params('smellnet').and_return(:undef)
    end
    it 'should re-raise exceptions other than lookup failure' do
      Socket.expects(:getservbyname).with('foo')\
        .raises(SocketError, 'something bad happened')
      expect(subject).to run.with_params('foo')\
        .and_raise_error(SocketError, 'something bad happened')
    end
  end

  context 'with protocol' do
    it 'should return expected result with valid input' do
      Socket.expects(:getservbyname).with('syslog', 'udp').returns(514)
      should run.with_params('syslog', 'udp').and_return(514)
    end

    it 'should get undef for unknown service' do
      Socket.expects(:getservbyname).with('smellnet', 'ddp')\
       .raises(SocketError, 'no such service smellnet/ddp')

      expect(subject).to run.with_params('smellnet', 'ddp').and_return(:undef)
    end

    it 'should re-raise exceptions other than lookup failure' do
      Socket.expects(:getservbyname).with('smellnet', 'ddp')\
        .raises(SocketError, 'something bad happened')
      expect(subject).to run.with_params('smellnet', 'ddp')\
        .and_raise_error(SocketError, 'something bad happened')
    end
  end
end
