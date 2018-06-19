# PhysitrackApi

A simple Ruby library for consuming the Physitrack API. This gem provides functionality to fetch data for the practitioner such as clients, exercises, programs, templates, messages and much more. All requests were tested with the `V2` version of Physitrack's API, for more information visit their docs [here](https://staging.physitrack.com/api/v2/apidocs#/clients/get_clients).

This open source project was commissioned by the good people at [Jane Software Inc.](https://www.janeapp.com), the maker of _"the best clinic management software. ever."_ For more information goto [www.janeapp.com](https://www.janeapp.com) or feel free to send Jane an [email](mailto:seejanerun@janeapp.com).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'physitrack_api'
```

And then execute:
```shell
$ bundle
```

Or install it yourself as:
```shell
$ gem install physitrack_api
```

## Ruby Version
`ruby-2.1.10 [ x86_64 ]`


## Usage

All methods take in keyword arguments for the parameters and return a `Physitrack::Response` object. The data from the API request is stored in the `payload` attribute, the `payload` can also be access using the `data` helper method. The response object also has `status`, `code`, and `message` attributes and has a `success?` helper method.

Below is a list of all requests that can be made with this client. Begin by instantiating a client object. Takes in two key word args, the `api_key` which belongs to the practitioner and a subdomain. Use the subdomain for your account/region, ie. `us`, `uk`, `ca`, `au` or `staging`.

Use the client object to make your requests.
```ruby
client = PhysitrackApi::Client.new(api_key: 'your_key', subdomain: 'staging')
```

Fetch all the practitioner's clients.
```ruby
response = client.get_all_clients

response.success? # check if the response was a success
response.payload  # JSON / Hash response from Physitrack
response.data     # Returns the exact same as payload
```

Find a client.
```ruby
client.find_client(id: 123)
```

Create a client. For more information on how to format the data in your body, refer to **[Physitrack's API Docs](https://staging.physitrack.com/api/v2/apidocs#/clients/get_clients)**
```ruby
params = {
  external_id: 'jane_patient_id-123',
  first_name: 'Jane',
  last_name: 'App',
  year_of_birth: 2012,
  gender: 'f',
  email: 'aliceson@janeapp.com',
  mobile_phone: '+16043105253'
}

client.create_client(body: params)
```

Update a client.
```ruby
params = {
  # ... whatever you want to change
}

client.update_client(id: 123, body: params)
```

Find a program.
```ruby
client.find_client_program(client_id: 123, access_code: 'qwertyiod')
```

Get all programs for a client.
```ruby
client.get_client_programs(client_id: 123)
```

Assign a program to a client.
```ruby
params = {
  template_id: 1200,
  external_id: "jane_app_patient_id",
  start_date: Time.now.strftime('%Y-%m-%d'),
  num_weeks: 8,
  track_adherence: true,
  track_pain_levels: true
}

client.assign_program(client_id: 123, body: params)
```

Update an assigned program. This request takes in only 1 attribute `end_date`. **WARNING:** if you set `end_date` to `nil` or send params as an empty hash, the API will end the program immediately!
```ruby
params = {
  end_date: Date.today + 1.month
}

client.update_client_program(client_id: 123, access_code: 'qwertyiod', body: params)
```

Send the client the access code to a program. Can be sent via `email` or `sms`.
```ruby
client.resend_access_code(client_id: 123, access_code: 'qwertyiod', via: 'email')
```

Fetch all the exercises related to a program. Pass in `pdf: true` to get a link to a pdf file.
```ruby
client.get_client_program_exercises(client_id: 123, access_code: 'qwertyiod', pdf: false)
```

Check on the client's progress and adherence.
```ruby
client.get_client_program_adherence(client_id: 123, access_code: 'qwertyiod')
```

Find client PROM.
```ruby
client.find_client_program_prom(client_id: 123, access_code: 'qwertyiod', id: 987)
```

Fetch all PROMs for a client.
```ruby
client.get_all_client_program_proms(client_id: 123, access_code: 'qwertyiod')
```

Find PROM results for a client's program.
```ruby
client.find_client_program_prom_results(client_id: 123, access_code: 'qwertyiod', id: 987)
```

Find a specific client message by id.
```ruby
client.find_client_message(client_id: 123, id: 222)
```

Fetch all messages between a client and practitioner.
```ruby
client.get_all_client_messages(client_id: 123)
```

Find a specific template.
```ruby
client.find_template(id: 1200)
```

Fetch all templates.
```ruby
client.get_all_templates
```

Fetch exercises.
```ruby
client.get_all_exercises

# Optionally pass in a query keyword argument to narrow down your search

client.get_all_exercises(query: 'strength')
```

Find a specific client event by id.
```ruby
client.find_event(id: 777)
```

Fetch all events.
```ruby
client.get_all_events
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jzntam/physitrack_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/jzntam/physitrack_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Code of Conduct

Everyone interacting in the PhysitrackApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jzntam/physitrack_api/blob/master/CODE_OF_CONDUCT.md).


## Thanks
<img src="https://uploads-ssl.webflow.com/564c698e77bcae4a222a98f2/569370585110149410401703_physiapp_logo.png" width="100" alt='Physitrack'/> &nbsp; &nbsp;<img src="https://www.janeapp.com/assets/jane-header-logo@2x-2c0b48359f53a8025428ae7551a38257.png" height="40" />
