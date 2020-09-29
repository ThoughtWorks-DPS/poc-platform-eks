
require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['TEST_ENV'] + '.auto.tfvars.json'))

describe eks(tfvars["cluster_name"]) do
  it { should exist }
  it { should be_active }
  its(:version) { should eq tfvars['cluster_version'] }
end

