# encoding: UTF-8

require 'spec_helper'

describe 'gethostbyname' do
  it 'should exist' do
    Puppet::Parser::Functions.function('gethostbyname')\
      .should eq 'function_gethostbyname'
  end

  it 'should return expected result with valid input' do
    Socket.expects(:gethostbyname).with('localhost').returns([
      'slocalhost', ['localhost.localdomain'],
      2, [127, 0, 0, 2].pack('CCCC')
    ])
    expected_result = {
      'name' => 'slocalhost',
      'aliases' => ['localhost.localdomain'],
      'address' => '127.0.0.2'
    }
    expect(subject).to run.with_params('localhost').and_return(expected_result)
  end

  # .invalid is reserved by RFC 2606
  it('should return undef on lookup failure', :slow => true) do
    expect(subject).to run.with_params('example.invalid').and_return(:undef)
  end

  it 'should return undef on stubbed lookup failure' do
    excp = [SocketError,
            'getaddrinfo: nodename nor servname provided, or not known']
    Socket.expects(:gethostbyname).with('localhost').raises(*excp)
    # Use 'localhost' to confirm that stub is working
    expect(subject).to run.with_params('localhost').and_return(:undef)
  end

  it 'should re-raise other exceptions' do
    excp = [SocketError, 'toast is burned']
    Socket.expects(:gethostbyname).with('localhost').raises(*excp)
    expect(subject).to run.with_params('localhost').and_raise_error(*excp)
  end
end
