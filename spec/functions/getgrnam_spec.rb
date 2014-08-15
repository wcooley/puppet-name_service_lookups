# encoding: UTF-8

require 'spec_helper'

describe 'getgrnam' do
  it 'should exist' do
    Puppet::Parser::Functions.function('getgrnam') \
      .should eq 'function_getgrnam'
  end

  it 'should return expected result with valid input' do
    grent_ary = [
      ['name', 'jensenb'],
      ['passwd', '*'],
      ['gid', 101],
      ['mem', ['wcooley']],
    ]
    grent_vals = grent_ary.collect { |k,v| v }
    grent_hash = Hash[grent_ary]

    grent_struct = Struct::Group[*grent_vals]

    Etc.expects(:getgrnam).with('jensenb').returns(grent_struct)

    #scope = PuppetlabsSpec::PuppetInternals.scope
    #expect(scope.function_getgrnam(['jensenb'])).to eq(grent_hash)
    expect(subject).to run.with_params('jensenb').and_return(grent_hash)
  end

  it 'should return undef on stubbed lookup failure' do
    Etc.expects(:getgrnam).with('zoot') \
      .raises(ArgumentError, "can't find group for zoot")
    expect(subject).to run.with_params('zoot').and_return(:undef)
  end

  it 'should re-raise exceptions other than lookup failure' do
    Etc.expects(:getgrnam).with('root') \
      .raises(ArgumentError, 'not the right argument')
    expect(subject).to run.with_params('root') \
      .and_raise_error(ArgumentError, 'not the right argument')
  end

end
