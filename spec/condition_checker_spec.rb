require "spec_helper"
require "condition_checker"

RSpec.describe ConditionChecker do
  class TestWebsite
    attr_accessor :database_connection, :api_status, :memory_usage, :response_time

    def initialize(database_connection: true, api_status: :ok, memory_usage: 500, response_time: 200)
      @database_connection = database_connection
      @api_status = api_status
      @memory_usage = memory_usage
      @response_time = response_time
    end

    def database_connected?
      @database_connection
    end

    def api_healthy?
      @api_status == :ok
    end
  end

  class MemoryChecker
    def self.call(website)
      website.memory_usage < 1000
    end
  end

  class ResponseTimeChecker
    def self.call(website)
      website.response_time < 300
    end
  end

  class WebsiteHealth
    include ConditionChecker::Mixin

    condition "database.connected", ->(website) { website.database_connected? }
    condition "api.healthy", ->(website) { website.api_healthy? }
    condition "memory.optimal", MemoryChecker
    condition "response_time.acceptable", ResponseTimeChecker

    def everything_ok
      true
    end

    check :critical_services, conditions: ["database.connected", "api.healthy"]
    check "performance.ok", conditions: ["memory.optimal", "response_time.acceptable"]
    check :all_systems_go, conditions: ["database.connected", "api.healthy", "memory.optimal", "response_time.acceptable", "everything_ok"]
  end

  let(:website) { TestWebsite.new }

  it "checks conditions correctly" do
    runner = WebsiteHealth.for(website)
    results = runner.checks
    expect(results.size).to eq(3)
    expect(results.map(&:success?)).to eql([true, true, true])
    all_systems = runner.find("all_systems_go")
    expect(all_systems).to be_success
    expect(all_systems.map { [_1.name, 1.value] }).to eql([])
  end

  context "with database issues" do
    let(:website) { TestWebsite.new(database_connection: false) }

    it "fails critical services check" do
      runner = WebsiteHealth.for(website)
      failing = runner.fails
      expect(failing.size).to eq(2)
      expect(failing.map(&:name)).to contain_exactly("critical_services", "all_systems_go")

      critical_services = failing.first
      expect(critical_services.fails.map(&:name)).to eql(["database.connected"])
    end
  end
end
