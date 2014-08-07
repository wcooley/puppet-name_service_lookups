# encoding: UTF-8

require 'spec_helper'

describe 'getpwuid' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getpwuid') \
      .should eq 'function_getpwuid'
  end

  context 'should return expected result with valid input' do
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
      Etc.stubs(:getpwuid).returns(pwent_struct)
    end

    context 'uid as Integer' do
      # The failure message is buggy in rspec-puppet 1.0.1
      # and not as readable as the default formatter when it does work
      it 'with rspec-puppet' do
        should(run.with_params(501).and_return(pwent_hash))
      end

      # Ruby 1.8.7 barfs with
      #   uninitialized constant RSpec::Expectations::Differ::Encoding
      it('using Puppet function directly', :if => RUBY_VERSION >= '1.9.0') do
        scope = PuppetlabsSpec::PuppetInternals.scope
        expect(scope.function_getpwuid([501])).to eq(pwent_hash)
      end
    end

    context 'uid as String' do
      it 'with rspec-puppet' do
        should(run.with_params('501').and_return(pwent_hash))
      end

      # Ruby 1.8.7 barfs with
      #   uninitialized constant RSpec::Expectations::Differ::Encoding
      it('using Puppet function directly', :if => RUBY_VERSION >= '1.9.0') do
        scope = PuppetlabsSpec::PuppetInternals.scope
        expect(scope.function_getpwuid(['501'])).to eq(pwent_hash)
      end
    end
  end

  it('should lookup UID 0 unstubbed', :slow => true) do
      scope = PuppetlabsSpec::PuppetInternals.scope
      result = scope.function_getpwuid([0])
      expect(result['name']).to eq('root')
      expect(result['uid']).to eq(0)
  end

  it 'should return undef on lookup failure' do
    # Use 'root' to confirm that stubbed exception is working
    Etc.expects(:getpwuid).with(0)\
      .raises(ArgumentError, "can't find user for root")
    expect(subject).to run.with_params(0).and_return(:undef)
  end

  it 'should re-raise other exceptions' do
    Etc.expects(:getpwuid).with(0)\
      .raises(ArgumentError, 'not the right argument')
    expect(subject).to run.with_params(0)\
      .and_raise_error(ArgumentError, 'not the right argument')
  end

  # Ruby "helpfully" returns 0 when 'to_i' cannot convert to Integer
  # so we test to ensure we're converting it correctly.
  # Also, note that *ArgumentError* is raised here, but in the example using a
  # manifest it is a *Puppet::Error*.
  it 'should raise error when given non-integers w/rspec-puppet' do
     expect(subject).to run.with_params('not-an-integer')\
      .and_raise_error(ArgumentError, /invalid value for Integer/)
  end

  it 'should raise error when given non-integers' do
    scope = PuppetlabsSpec::PuppetInternals.scope
    expect {
      scope.function_getpwuid(['not-an-integer'])
    }.to(raise_error(ArgumentError, /invalid value for Integer/))
  end

end
