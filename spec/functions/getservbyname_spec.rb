# encoding: UTF-8

require 'spec_helper'

describe 'getservbyname' do
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
