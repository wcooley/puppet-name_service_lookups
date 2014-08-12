# encoding: UTF-8

require 'spec_helper'

describe 'getpwnam' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getpwnam') \
      .should eq 'function_getpwnam'
  end

  context 'should run and return stubbed results' do
    pwent_ars = [
        ['name', 'jensenb'],
        ['passwd', '********'],
        ['uid', 501],
        ['gid', 101],
        ['gecos', 'Babs Jensen'],
        ['dir', '/home/jensenb'],
        ['shell', '/bin/tcsh']
    ]
    pwent_vals = pwent_ars.collect { |k,v| v }
    pwent_hash = Hash[pwent_ars]

    pwent_struct = Struct::Passwd[*pwent_vals]

    before(:each) do
      Etc.stubs(:getpwnam).returns(pwent_struct)
    end

    # The failure message is buggy in rspec-puppet 1.0.1
    # and not as readable as the default formatter when it does work
    it 'with rspec-puppet' do
      should(run.with_params('jensenb').and_return(pwent_hash))
    end

    # Ruby 1.8.7 barfs with
    #   uninitialized constant RSpec::Expectations::Differ::Encoding
    it('using Puppet function directly', :if => RUBY_VERSION >= '1.9.0') do
      scope = PuppetlabsSpec::PuppetInternals.scope
      expect(scope.function_getpwnam(['jensenb'])).to eq(pwent_hash)
    end
  end

  it('should lookup root unstubbed', :slow => true) do
      scope = PuppetlabsSpec::PuppetInternals.scope
      result = scope.function_getpwnam(['root'])
      expect(result['name']).to eq('root')
      expect(result['uid']).to eq(0)
  end

  it 'should return undef on lookup failure' do
    # Use 'root' to confirm that stubbed exception is working
    Etc.expects(:getpwnam).with('root')\
      .raises(ArgumentError, "can't find user for root")
    expect(subject).to run.with_params('root').and_return(:undef)
  end

  it 'should re-raise other exceptions' do
    Etc.expects(:getpwnam).with('root')\
      .raises(ArgumentError, 'not the right argument')
    expect(subject).to run.with_params('root')\
      .and_raise_error(ArgumentError, 'not the right argument')
  end
end
