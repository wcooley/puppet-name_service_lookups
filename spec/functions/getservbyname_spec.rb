# encoding: UTF-8

require 'spec_helper'

describe 'getservbyname' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getservbyname') \
      .should eq 'function_getservbyname'
  end

  context 'without protocol' do
    it 'should return expected result with valid input' do
      Socket.stubs(:getservbyname).returns(23)
      should run.with_params('telnet').and_return(23)
    end
    it 'should return undef on lookup failure'
    it 'should re-raise exceptions other than lookup failure'
  end

  context 'with protocol' do
    it 'should return expected result with valid input' do
      Socket.stubs(:getservbyname).returns(514)
      should run.with_params('syslog', 'udp').and_return(514)
    end
    it 'should get undef for unknown service'
    it 'should re-raise exceptions other than lookup failure'
  end
end
