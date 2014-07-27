# encoding: UTF-8

require 'spec_helper'

describe 'gethostbyaddr' do
  it 'should exist' do
    Puppet::Parser::Functions.function('gethostbyaddr')\
      .should eq 'function_gethostbyaddr'
  end

  it 'should run and return stubbed results' do
    Socket.stubs(:gethostbyaddr).returns([
      'slocalhost', ['localhost.localdomain'],
      2, [127, 0, 0, 2].pack('CCCC')
    ])
    expected_result = {
      'name'    => 'slocalhost',
      'aliases' => ['localhost.localdomain'],
      'address' => '127.0.0.2'
    }
    expect(subject).to run.with_params('127.0.0.2').and_return(expected_result)
  end

  # 192.0.2.0/24 is TEST-NET-1 per RFC 5737
  it 'should return undef on lookup failure' do
  pending 'lookup failure handling' do
    expect(subject).to run.with_params('192.0.2.1').and_return(:undef)
  end
  end
end
