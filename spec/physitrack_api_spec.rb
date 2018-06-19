RSpec.describe PhysitrackApi do
  it "has a version number" do
    expect(PhysitrackApi::VERSION).not_to be nil
  end

  it "is namespaced properly" do
    client = PhysitrackApi::Client.new(api_key: 'key', subdomain: 'staging')
    expect(client).to be_present
  end
end
