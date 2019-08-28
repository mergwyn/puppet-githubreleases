# frozen_string_literal: true

require 'spec_helper'

describe 'github_release' do
  use_auth = false
  use_oauth = false
  username = ''
  password = ''

  if ENV['GITHUB_USE_AUTH']
    use_auth = true
    username = ENV['GITHUB_USERNAME']
    password = ENV['GITHUB_PASSWORD']
  end

  use_oauth = true if ENV['GITHUB_USE_OAUTH']

  it 'gives the HEAD tarball URL' do
    is_expected.to run.with_params(
      'puppetlabs',
      'puppet',
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      'https://github.com/puppetlabs/puppet/archive/master.tar.gz',
    )
  end

  it 'gives the HEAD zipball URL' do
    is_expected.to run.with_params(
      'puppetlabs',
      'puppet',
      use_zip: true,
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      'https://github.com/puppetlabs/puppet/archive/master.zip',
    )
  end

  it 'gives the HEAD tarball URL for a repository with actual releases' do
    is_expected.to run.with_params(
      'Graylog2',
      'collector-sidecar',
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      %r{https://api\.github\.com/repos/Graylog2/collector-sidecar/tarball/},
    )
  end

  it 'gives a tarball of a specific release' do
    is_expected.to run.with_params(
      'Graylog2',
      'collector-sidecar',
      release: '0.0.2',
      is_tag: true,
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      %r{https://api\.github\.com/repos/Graylog2/collector-sidecar/tarball/0\.0\.2},
    )
  end

  it 'give a zipball of a specific release' do
    is_expected.to run.with_params(
      'Graylog2',
      'collector-sidecar',
      release: '0.0.2',
      use_zip: true,
      is_tag: true,
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      %r{https://api\.github\.com/repos/Graylog2/collector-sidecar/zipball/0.0.2},
    )
  end

  it 'give a matching content_type package' do
    is_expected.to run.with_params(
      'Graylog2',
      'collector-sidecar',
      release: '0.0.2',
      is_tag: true,
      asset: true,
      asset_contenttype: 'application/x-deb',
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      'https://github.com/Graylog2/collector-sidecar/releases/download/0.0.2/collector-sidecar_0.0.2-1_amd64.deb',
    )
  end

  it 'give a matching filename' do
    is_expected.to run.with_params(
      'Graylog2',
      'collector-sidecar',
      release: '0.0.2',
      is_tag: true,
      asset: true,
      asset_filepattern: 'graylog_collector_sidecar_installer\.exe',
      use_auth: use_auth,
      use_oauth: use_oauth,
      username: username,
      password: password,
    ).and_return(
      'https://github.com/Graylog2/collector-sidecar/releases/download/0.0.2/graylog_collector_sidecar_installer.exe',
    )
  end
end
