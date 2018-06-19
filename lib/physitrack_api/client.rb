require "httparty"
require 'active_support/all'

module PhysitrackApi
  class Client
    def initialize(api_key:, subdomain:)
      raise ArgumentError.new('You must provide a Physitrack API Key')   unless api_key.present?
      raise ArgumentError.new('You must provide a Physitrack subdomain') unless subdomain.present?

      @api_key   = api_key
      @subdomain = subdomain
    end

    # Find a single client by id
    def find_client(id:)
      response = get("clients/#{id}")
      PhysitrackApi::Response.from(response)
    end

    # Fetch all clients for practitioner, recursively. Paginated request.
    def get_all_clients(page: 1, clients: [])
      response = get("clients?page=#{page}")

      return PhysitrackApi::Response.from(response) unless response.success?

      clients += response['clients']

      if response['clients'].try(:size) == 200
        get_all_clients(page: page + 1, clients: clients)
      else
        PhysitrackApi::Response.from(response, payload: { 'clients' => clients })
      end
    end

    # Create a single client
    # body = {
    #   external_id:   Required unique id,
    #   first_name:    Required,
    #   last_name:     Required,
    #   year_of_birth: Required,
    #   gender:        Required m or f,
    #   email:         Optional,
    #   mobile_phone:  Optional '+16043105253'
    # }
    def create_client(body:)
      response = post('clients/', body: body)

      PhysitrackApi::Response.from(response)
    end

    # Create a single client
    # Uses same body structure as create_client
    def update_client(id:, body:)
      response = put("clients/#{id}", body: body)

      PhysitrackApi::Response.from(response)
    end

    # Find a single program using client_id and access_code
    def find_client_program(client_id:, access_code:)
      response = get("clients/#{client_id}/programs/#{access_code}")

      PhysitrackApi::Response.from(response)
    end

    # Find all programs for the client. Paginated request
    def get_client_programs(client_id:, page: 1, programs: [])
      response  = get("clients/#{client_id}/programs?page=#{page}")

      return PhysitrackApi::Response.from(response) unless response.success?

      programs += response['programs']

      if response['programs'].try(:size) == 200
        get_client_programs(client_id: client_id, page: page + 1, programs: programs)
      else
        PhysitrackApi::Response.from(response, payload: { 'programs' => programs })
      end
    end

    # Assign a program to a client
    # body = {
    #   template_id:       Required,
    #   external_id:       Optional,
    #   start_date:        Required 2018-06-13T00:00:00Z ISO8601 format,
    #   num_weeks:         Optional inheirits from template,
    #   track_adherence:   Optional inheirits from template,
    #   track_pain_levels: Optional inheirits from template,
    # }
    def assign_program(client_id:, body:)
      response = post("clients/#{client_id}/programs", body: body)

      PhysitrackApi::Response.from(response)
    end

    # Update a program that has already been assigned to a client
    # If left empty, then end date is set to today, and program is ended.
    # body = {
    #   end_date: Required 2018-06-13T00:00:00Z ISO8601 format
    # }
    # body = {
    #   end_date: nil
    # }
    def update_client_program(client_id:, access_code:, body:)
      response = put("clients/#{client_id}/programs/#{access_code}", body: body)

      PhysitrackApi::Response.from(response)
    end

    # Send the client the program access code, 'sms' or 'email'. Defaults to email.
    def resend_access_code(client_id:, access_code:, via: 'email')
      response = post("clients/#{client_id}/programs/#{access_code}/resend?via=#{via}", body: {})

      PhysitrackApi::Response.from(response)
    end

    # Get all the exercises for a program assigned to a client
    # The default format will return a hashable object containing the entire
    # exercise routine for the duration of the program.
    # The pdf format will return a url linking to a personalized pdf document
    # containing just the exercise descriptions for the program.
    def get_client_program_exercises(client_id:, access_code:, pdf: false)
      pdf_file = "?format=pdf" if pdf
      response = get("clients/#{client_id}/programs/#{access_code}/exercises#{pdf_file}")

      PhysitrackApi::Response.from(response)
    end

    # Adherence & pain levels for all exercises inside this access code.
    def get_client_program_adherence(client_id:, access_code:)
      response = get("clients/#{client_id}/programs/#{access_code}/adherence")

      PhysitrackApi::Response.from(response)
    end

    # Find a PROM assigned to a program
    def find_client_program_prom(client_id:, access_code:, id:)
      response = get("clients/#{client_id}/programs/#{access_code}/proms/#{id}")

      PhysitrackApi::Response.from(response)
    end

    # Get all PROMS attached to a program
    def get_all_client_program_proms(client_id:, access_code:)
      response = get("clients/#{client_id}/programs/#{access_code}/proms")

      PhysitrackApi::Response.from(response)
    end

    # Find a PROM results for a client's program
    def find_client_program_prom_results(client_id:, access_code:, id:)
      response = get("clients/#{client_id}/programs/#{access_code}/proms/#{id}/results")

      PhysitrackApi::Response.from(response)
    end

    # Find a single message for a client by id
    def find_client_message(client_id:, id:)
      response = get("clients/#{client_id}/messages/#{id}")

      PhysitrackApi::Response.from(response)
    end

    # Get all messages associated with the client
    def get_all_client_messages(client_id:)
      response = get("clients/#{client_id}/messages")

      PhysitrackApi::Response.from(response)
    end

    # Find a template by it's id. ie. program, workout, routine etc.
    def find_template(id:)
      response = get("templates/#{id}")

      PhysitrackApi::Response.from(response)
    end

    # Get all templates that are available to the practitioner.
    def get_all_templates(page: 1, templates: [])
      response = get("templates?page=#{page}")

      return PhysitrackApi::Response.from(response) unless response.success?

      templates += response['templates']

      if response['templates'].try(:size) == 200
        get_all_templates(page: page + 1, templates: templates)
      else
        PhysitrackApi::Response.from(response, payload: { 'templates' => templates })
      end
    end

    # Find all programs for the client. This method can take an optional query
    # keyword argument that will search exercises based on the name
    def get_all_exercises(query: nil, page: 1, exercises: [])
      search_params = "name=#{query}&" if query
      query_string  = "#{search_params}page=#{page}"
      response      = get("exercises?#{query_string}")

      return PhysitrackApi::Response.from(response) unless response.success?

      exercises    += response['exercises']

      if response['exercises'].try(:size) == 200
        get_all_exercises(query: query, page: page + 1, exercises: exercises)
      else
        PhysitrackApi::Response.from(response, payload: { 'exercises' => exercises })
      end
    end

    # Find a event by it's id.
    def find_event(id:)
      response = get("events/#{id}")

      PhysitrackApi::Response.from(response)
    end

    # Get all events that occured on the practitioner's account.
    def get_all_events(page: 1, events: [])
      response = get("events?page=#{page}")

      return PhysitrackApi::Response.from(response) unless response.success?

      events += response['events']

      if response['events'].try(:size) == 200
        get_all_events(page: page + 1, events: events)
      else
        PhysitrackApi::Response.from(response, payload: { 'events' => events })
      end
    end

    private

    def base_url
      "https://#{@subdomain}.physitrack.com/api/v2/"
    end

    def default_headers
      {
        'accept'       => 'application/json',
        'Content-Type' => 'application/json',
        'X-Api-Key'    => "#{@api_key}"
      }
    end

    def get(path)
      HTTParty.get("#{base_url}#{path}",
        headers: default_headers
      )
    end

    def post(path, body:)
      HTTParty.post("#{base_url}#{path}",
        headers: default_headers,
        body:    body.to_json
      )
    end

    def put(path, body:)
      HTTParty.put("#{base_url}#{path}",
        headers: default_headers,
        body:    body.to_json
      )
    end
  end
end
