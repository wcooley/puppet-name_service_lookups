require 'spec_helper'

describe 'gethostbyname' do
  it 'should run and return stubbed results' do
    Socket.stubs(:gethostbyname).returns([
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
  end
end
