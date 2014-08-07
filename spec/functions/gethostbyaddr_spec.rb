# encoding: UTF-8

require 'spec_helper'

describe 'gethostbyaddr' do
  it 'should exist' do
    Puppet::Parser::Functions.function('gethostbyaddr')\
      .should eq 'function_gethostbyaddr'
  end

  it 'should return expected result with valid input' do
    Socket.expects(:gethostbyaddr).with("\x7F\x00\x00\x02").returns([
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
  it('should return undef on lookup failure', :slow => true) do
    expect(subject).to run.with_params('192.0.2.1').and_return(:undef)
  end

  it 'should return undef on stubbed lookup failure' do
    Socket.expects(:gethostbyaddr).with("\x7F\x00\x00\x01")\
      .raises(SocketError, 'host not found')
    expect(subject).to run.with_params('127.0.0.1').and_return(:undef)
  end

  it 'should re-raise other execptions' do
    Socket.expects(:gethostbyaddr).with("\x7F\x00\x00\x01")\
      .raises(SocketError, 'toast is burned')
    expect(subject).to run.with_params('127.0.0.1')\
      .and_raise_error(SocketError, 'toast is burned')
  end
end
