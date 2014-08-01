# encoding: UTF-8

require 'spec_helper'

describe 'getservbyname' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getservbyname') \
      .should eq 'function_getservbyname'
  end

  context 'basic' do
    it '' do
      should run.with_params('telnet').and_return(23)
    end
  end

  context 'with protocol' do
    it '' do
      should run.with_params('syslog', 'udp').and_return(514)
    end
  end
end
