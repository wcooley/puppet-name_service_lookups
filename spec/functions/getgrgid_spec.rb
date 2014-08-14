# encoding: UTF-8

require 'spec_helper'

describe 'getgrgid' do

  it 'should exist' do
    Puppet::Parser::Functions.function('getgrgid') \
      .should eq 'function_getgrgid'
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

    Etc.expects(:getgrgid).with(101).returns(grent_struct)
    expect(subject).to run.with_params(101).and_return(grent_hash)
  end

  it 'should return undef on stubbed lookup failure' do
    Etc.expects(:getgrgid).with(1010) \
      .raises(ArgumentError, "can't find group for 1010")
    expect(subject).to run.with_params(1010).and_return(:undef)
  end

  it 'should re-raise exceptions other than lookup failure' do
    Etc.expects(:getgrgid).with(0101) \
      .raises(ArgumentError, 'not the right argument')
    expect(subject).to run.with_params(0101) \
      .and_raise_error(ArgumentError, 'not the right argument')
  end

  it 'should raise error for non-integer input' do
    expect(subject).to run.with_params('not-an-integer') \
      .and_raise_error(ArgumentError, /invalid value for Integer/)
  end
end
