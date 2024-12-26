# ConditionChecker

ConditionChecker is a Ruby gem that provides a flexible way to define and check conditions on objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'condition_checker'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install condition_checker

## Structure

- `ConditionChecker::Mixin` is the main module that provides the DSL's `condition` and `check` methods. (see below for usage). 

- A *check* is a named collection of *conditions* with a single success/fail status. It can have one more more *conditions*
- A *condition* is a named rule that evaluates to either success or failure when run against an object. Each condition holds callable code (a proc/lambda/class with `call` method) that runs its condition check and returns a result.
  
You can get the results of all checks by calling your instance's `checks` method. `successes` and `fails` return a subset of `checks`. If you are not interested in specific checks, you can use `success?` and `fail?` to get the overall status.

## Usage

### Basic Setup

```ruby
class WebsiteHealth
  extend ConditionChecker::Mixin

  # Define individual conditions
  condition "database.connected", ->(website) { website.database_connected? }
  condition "api.healthy", ->(website) { website.api_healthy? }
  condition "memory.optimal", MemoryChecker  # calls MemoryChecker.call(website)
  condition "response_time.acceptable", ResponseTimeChecker

  # Group conditions into meaningful checks
  check :critical_services, conditions: ["database.connected", "api.healthy"]
  check "performance.ok", conditions: ["memory.optimal", "response_time.acceptable"]
  check :all_systems_go, conditions: ["database.connected", "api.healthy", "memory.optimal", "response_time.acceptable"]
end
```

### Running Checks

```ruby
# Create a checker instance for your object
checker = WebsiteHealth.for(website)

# Check if everything passed
if checker.fails.empty?
  puts "All systems operational!"
else
  puts "Found #{checker.fails.size} failing checks"
end

# Get specific check results
critical_check = checker.checks.find { |check| check.name == "critical_services" }
if critical_check.success?
  puts "Critical services are up!"
else
  puts "Critical service issues: #{critical_check.fails.map(&:name).join(', ')}"
end

# Get all failing conditions
failing_conditions = checker.fails.flat_map(&:fails)
failing_conditions.each do |condition|
  puts "Failed: #{condition.name}"
end

# Example
class SystemMonitor
  def self.generate_health_report(website)
    checker = WebsiteHealth.for(website)
    
    {
      status: checker.fails.empty? ? :healthy : :unhealthy,
      total_checks: checker.checks.size,
      failing_checks: checker.fails.size,
      critical_services: checker.checks.find { |c| c.name == "critical_services" }.success?,
      failures: checker.fails.map { |check|
        {
          check: check.name,
          failed_conditions: check.fails.map(&:name)
        }
      }
    }
  end
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/modsognir/condition_checker.
