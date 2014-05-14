require 'spec_helper'

describe 'gethostbyname' do
  context 'basic' do
    it do
      should run.with_params('localhost').and_return({
        'name' => 'localhost',
        'aliases' => [],
        'address' => '127.0.0.1',
      })
    end
  end
end
