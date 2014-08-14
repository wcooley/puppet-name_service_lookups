# encoding: UTF-8

require 'spec_helper'

# getservbyport not supported in Ruby 1.8
describe 'getservbyport', :if => RUBY_VERSION >= '1.9.0' do
  it 'should exist' do
    Puppet::Parser::Functions.function('getservbyport') \
      .should eq 'function_getservbyport'
  end

  context 'without protocol' do

    it 'should return expected result with valid input' do
      Socket.expects(:getservbyport).with(514).returns('shell')
      expect(subject).to run.with_params(514).and_return('shell')
    end

    it 'should raise error for non-integer input' do
      expect(subject).to run.with_params('not-an-integer') \
        .and_raise_error(ArgumentError, /invalid value for Integer/)
    end

    it 'should return undef on lookup failure' do
      Socket.expects(:getservbyport).with(0) \
        .raises(SocketError, 'no such service for port 0/tcp')
      expect(subject).to run.with_params(0).and_return(:undef)
    end

    it 'should re-raise exceptions other than lookup failure' do
      Socket.expects(:getservbyport).with(0) \
        .raises(ArgumentError, 'not the right argument')
      expect(subject).to run.with_params(0) \
        .and_raise_error(ArgumentError, /not the right argument/)
    end
  end

  context 'with protocol' do

    it 'should return expected result with valid input' do
      Socket.expects(:getservbyport).with(514, 'udp').returns('syslog')
      expect(subject).to run.with_params(514, 'udp').and_return('syslog')
    end

    it 'should raise error for non-integer input' do
      expect(subject).to run.with_params('not-an-integer', 'udp') \
        .and_raise_error(ArgumentError, /invalid value for Integer/)
    end

    it 'should return undef on lookup failure' do
      Socket.expects(:getservbyport).with(0, 'tcp') \
        .raises(SocketError, 'no such service for port 0/tcp')
      expect(subject).to run.with_params(0, 'tcp').and_return(:undef)
    end

    it 'should re-raise exceptions other than lookup failure' do
      Socket.expects(:getservbyport).with(0, 'udp') \
        .raises(ArgumentError, 'not the right argument')
      expect(subject).to run.with_params(0, 'udp') \
        .and_raise_error(ArgumentError, /not the right argument/)
    end
  end

end
