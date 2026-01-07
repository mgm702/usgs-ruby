# **usgs-ruby**

[![Build Status](https://github.com/mgm702/usgs-ruby/actions/workflows/main.yml/badge.svg)](https://github.com/mgm702/usgs-ruby/actions)
[![Gem Version](https://badge.fury.io/rb/usgs-ruby.svg)](https://badge.fury.io/rb/usgs-ruby)
[![MIT license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

[**« USGS »**](https://www.usgs.gov/)

[**USGS Water Services**](https://waterservices.usgs.gov/)

The goal of [**`usgs-ruby`**](https://rubygems.org/gems/usgs-ruby) is to provide functions that help Ruby users to navigate, explore, and make requests to the USGS Water Services API. 

The United States Geological Survey (USGS) Water Services provides access to water resources data collected at approximately 1.9 million sites across the United States. This includes real-time and historical data for streamflow, groundwater levels, water quality, and more.

Thank you to the USGS for providing an accessible and well-documented API!

---

## **Installation**

Add this line to your application's Gemfile:

```ruby
gem 'usgs-ruby'
```

and then execute:

```bash
bundle install
```

or install it yourself as:

```bash
gem install usgs-ruby
```

## **Getting Started**

Using the gem is simple. Create a client and start making requests:

```ruby
require 'usgs'

# Create a client
client = Usgs.client

# Get site information
sites = client.get_sites(state_cd: "CO", parameter_cd: :discharge)

# Get daily values (last 24 hours by default)
readings = client.get_dv(sites: "06754000", parameter_cd: :discharge)

# Get instantaneous values
iv_readings = client.get_iv(sites: "06754000", parameter_cd: :discharge)

# Get statistics
stats = client.get_stats(sites: "06754000", report_type: :daily)
```

## **Available Endpoints**

The `usgs-ruby` gem provides access to all major USGS Water Services endpoints through an intuitive interface. For detailed documentation on each endpoint and its methods, please visit our [documentation site](https://mgm702.github.io/usgs-ruby).

### Key Modules:

* **Daily Values (DV)** - Access daily streamflow, groundwater, and water quality data
  ```ruby
  client.get_dv(sites: "06754000", parameter_cd: :discharge, 
                start_date: "2023-01-01", end_date: "2023-12-31")
  ```

* **Instantaneous Values (IV)** - Get real-time water data (15-minute intervals)
  ```ruby
  client.get_iv(sites: "06754000", parameter_cd: :discharge)
  ```

* **Site Information** - Search and retrieve monitoring location metadata
  ```ruby
  client.get_sites(state_cd: "CO", site_type: "ST", parameter_cd: :discharge)
  ```

* **Statistics** - Access statistical summaries (daily, monthly, annual)
  ```ruby
  client.get_stats(sites: "06754000", report_type: :annual, 
                   stat_year_type: "water")
  ```

### Supported Parameter Codes:

The gem includes convenient symbols for common parameters:

- `:discharge` - Streamflow (cubic feet per second)
- `:gage_height` - Gage height (feet)
- `:temperature` - Water temperature (°C)
- `:precipitation` - Precipitation (inches)
- `:do` - Dissolved oxygen (mg/L)
- `:conductivity` - Specific conductance (µS/cm)
- `:ph` - pH

You can also use USGS parameter codes directly (e.g., `"00060"` for discharge).

## **Examples**

### Finding Sites

```ruby
# Search by state
sites = client.get_sites(state_cd: "CO")

# Search by bounding box (west, south, east, north)
sites = client.get_sites(bBox: "-105.5,39.5,-105.0,40.0")

# Search by site name
sites = client.get_sites(site_name: "Boulder Creek")

# Filter by site type and parameter
sites = client.get_sites(state_cd: "CO", site_type: "ST", 
                         parameter_cd: :discharge)
```

### Retrieving Data

```ruby
# Get recent daily values
readings = client.get_dv(sites: "06754000", parameter_cd: :discharge)

# Get historical daily values
readings = client.get_dv(
  sites: "06754000",
  parameter_cd: :discharge,
  start_date: Date.parse("2020-01-01"),
  end_date: Date.parse("2023-12-31")
)

# Get multiple parameters
readings = client.get_dv(
  sites: "06754000",
  parameter_cd: [:discharge, :gage_height]
)

# Get data from multiple sites
readings = client.get_dv(
  sites: ["06754000", "06752000"],
  parameter_cd: :discharge
)
```

### Working with Statistics

```ruby
# Daily statistics
stats = client.get_stats(sites: "06754000", report_type: :daily)

# Monthly statistics
stats = client.get_stats(sites: "06754000", report_type: :monthly)

# Annual statistics (water year)
stats = client.get_stats(
  sites: "06754000", 
  report_type: :annual,
  stat_year_type: "water"
)
```

## **Configuration**

You can configure the client with custom options:

```ruby
Usgs.configure do |config|
  config.user_agent = "MyApp/1.0 (contact@example.com)"
end

client = Usgs.client
```

## **Development**

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

### Running Tests

```bash
bundle exec rake test
```

### Generating Documentation

```bash
bundle exec yard doc
open doc/index.html
```

### Running RuboCop

```bash
bundle exec rubocop
```

## **Testing**

This gem uses VCR for recording HTTP interactions during testing. When writing tests:

1. Tests will record real API responses on first run
2. Subsequent runs use cached responses (cassettes)
3. Cassettes are stored in `test/fixtures/vcr_cassettes/`

## **Contributing**

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-new-feature`)
3. Write tests for your changes
4. Make your changes and ensure tests pass (`rake test`)
5. Run RuboCop and fix any violations (`rubocop`)
6. Commit your changes with clear, descriptive messages
7. Push to your branch (`git push origin feature/my-new-feature`)
8. Create a Pull Request

Please make sure that your commit messages are clear and understandable.

## **Documentation**

Full API documentation is available at [https://mgm702.github.io/usgs-ruby](https://mgm702.github.io/usgs-ruby)

## **Resources**

- [USGS Water Services](https://waterservices.usgs.gov/)
- [USGS Water Services REST API Documentation](https://waterservices.usgs.gov/rest/Site-Service.html)
- [USGS Parameter Codes](https://help.waterdata.usgs.gov/parameter_cd?group_cd=%)

## **License**

The usgs-ruby gem is licensed under the MIT license. See [LICENSE](LICENSE) for details.

## **Acknowledgments**

- Thanks to the USGS for maintaining an excellent public API
- Inspired by similar projects in other languages

## **Support**

If you encounter any issues or have questions:

1. Check the [documentation](https://mgm702.github.io/usgs-ruby)
2. Search existing [GitHub Issues](https://github.com/mgm702/usgs-ruby/issues)
3. Open a new issue with a clear description and example code

---

## Like The Gem?

If you like usgs-ruby follow the repository on [Github](https://github.com/mgm702/usgs-ruby) and if you are feeling extra nice, follow the author [mgm702](http://mgm702.com) on [Twitter](https://twitter.com/mgm702) or [Github](https://github.com/mgm702).

