require 'spec_helper'

describe 'gethostbyaddr' do
  context 'basic' do
    it do
      should run.with_params('127.0.0.1').and_return({
        'name' => 'localhost',
        'aliases' => ['1.0.0.127.in-addr.arpa'],
        'address' => '127.0.0.1',
      })
    end
  end
end
