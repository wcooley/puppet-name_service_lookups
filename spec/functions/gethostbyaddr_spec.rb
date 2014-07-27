require 'spec_helper'

describe 'gethostbyaddr' do
  it 'should run and return stubbed results' do
    Socket.stubs(:gethostbyaddr).returns([
        "slocalhost", ["localhost.localdomain"],
        2, [127,0,0,2].pack("CCCC")
      ])
    expected_result = {
      'name'    => 'slocalhost',
      'aliases' => ['localhost.localdomain'],
      'address' => '127.0.0.2',
    }
    expect(subject).to run.with_params('127.0.0.2').and_return(expected_result)
  end
end
