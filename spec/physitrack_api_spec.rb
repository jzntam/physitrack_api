RSpec.describe PhysitrackApi::Client do
  let(:api_client)  { PhysitrackApi::Client.new(api_key: 'valid_api_key', subdomain: 'staging') }

  EXPECTED_CLIENT_ERRORS = [
    'external_id is missing',
    'first_name is missing',
    'last_name is missing',
    'gender is missing',
    'gender must be one of: m, f',
    'year_of_birth is missing'
  ]

  context 'connecting to the Physitrack API' do
    context 'successful request with valid api_key' do
      it 'returns a PhysitrackApi::Response object' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response).to be_a(PhysitrackApi::Response)
        end
      end

      it 'returns a response with status code 200' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.code).to eq(200)
        end
      end

      it 'returns a response with the message ok' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.message).to eq('OK')
        end
      end

      it 'has a status of true and success? returns true' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.status).to eq(true)
          expect(response.success?).to eq(true)
        end
      end

      it 'has a payload and that payload is a Hash' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.payload).not_to be_empty
          expect(response.payload).to be_a(Hash)
        end
      end

      it 'responds to attributes' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.attributes).to be_an(Array)
          expect(response.attributes).to eq(['clients'])
        end
      end

      it 'raises an error when trying to access a key that does not exist' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect { response.dude }.to raise_error(NoMethodError)
        end
      end
    end

    context 'successful request with invalid api_key' do
      let(:bad_api_client)  { PhysitrackApi::Client.new(api_key: 'bad_api_key', subdomain: 'staging') }

      it 'returns a PhysitrackApi::Response object' do
        VCR.use_cassette('physitrack/invalid_api_key') do
          response = bad_api_client.get_all_clients

          expect(response).to be_a(PhysitrackApi::Response)
        end
      end

      it 'returns a response with status code 401' do
        VCR.use_cassette('physitrack/invalid_api_key') do
          response = bad_api_client.get_all_clients

          expect(response.code).to eq(401)
        end
      end

      it 'returns a response with the message Unauthorized' do
        VCR.use_cassette('physitrack/invalid_api_key') do
          response = bad_api_client.get_all_clients

          expect(response.message).to eq('Unauthorized')
        end
      end

      it 'has a status of true and success? returns true' do
        VCR.use_cassette('physitrack/invalid_api_key') do
          response = bad_api_client.get_all_clients

          expect(response.status).to eq(false)
          expect(response.success?).to eq(false)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/invalid_api_key') do
          response = bad_api_client.get_all_clients

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.errors).to include('Practitioner was not found')
        end
      end
    end
  end # connecting to the Physitrack API

  describe '#initialize' do
    it 'requires an api_key and subdomain keyword arguments' do
      expect {
        PhysitrackApi::Client.new()
      }.to raise_error(ArgumentError, 'missing keywords: api_key, subdomain')
    end

    it 'requires an api_key keyword argument' do
      expect {
        PhysitrackApi::Client.new(subdomain: 'canada')
      }.to raise_error(ArgumentError, 'missing keyword: api_key')
    end

    it 'requires a subdomain keyword argument' do
      expect {
        PhysitrackApi::Client.new(api_key: '12345')
      }.to raise_error(ArgumentError, 'missing keyword: subdomain')
    end

    it 'raises an ArgumentError when nil is passed in as the api_key' do
      expect {
        PhysitrackApi::Client.new(api_key: nil, subdomain: 'canada')
      }.to raise_error(ArgumentError, 'You must provide a Physitrack API Key')
    end

    it 'raises an ArgumentError when nil is passed in as subdomain' do
      expect {
        PhysitrackApi::Client.new(api_key: '12345', subdomain: nil)
      }.to raise_error(ArgumentError, 'You must provide a Physitrack subdomain')
    end

    it 'assigns an api_key instance variable' do
      api_client = PhysitrackApi::Client.new(api_key: '12345', subdomain: 'canada')
      expect(api_client.instance_variable_get('@api_key')).to eq('12345')
    end

    it 'assigns an subdomain instance variable' do
      api_client = PhysitrackApi::Client.new(api_key: '12345', subdomain: 'canada')
      expect(api_client.instance_variable_get('@subdomain')).to eq('canada')
    end
  end # #initialize

  describe '#find_client' do
    context 'successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 7961)

          expect(response).to be_a(PhysitrackApi::Response)
        end
      end

      it 'responds to success? and has a payload hash' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 7961)

          expect(response.success?).to eq(true)
          expect(response.payload).to be_a(Hash)
        end
      end

      it 'returns the correct client' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 7961)

          expect(response.id).to eq(7961)
          expect(response.first_name).to eq('Gilfoyle')
          expect(response.last_name).to eq('Bertram')
        end
      end
    end

    context 'unsuccessful request, client not found' do
      it 'returns the response wrapped in an object' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 98765)

          expect(response).to be_a(PhysitrackApi::Response)
        end
      end

      it 'is not valid?' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 98765)

          expect(response.success?).to be(false)
        end
      end

      it 'has an errors hash with messages' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 98765)

          expect(response.errors).to be_an(Array)
          expect(response.errors).to_not be_empty
          expect(response.errors).to include('Client with given id does not exist')
        end
      end

      it 'returns a 404 status code and Not Found message' do
        VCR.use_cassette('physitrack/find_client') do
          response = api_client.find_client(id: 98765)

          expect(response.code).to eq(404)
          expect(response.message).to eq('Not Found')
        end
      end
    end
  end # #find_client

  describe '#get_all_clients' do
    context 'successful request' do
      it 'returns the response wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response).to be_a(PhysitrackApi::Response)
        end
      end

      it 'returns the correct number of clients' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.clients.length).to eq(257)
        end
      end

      it 'responds to success? and has a clients hash' do
        VCR.use_cassette('physitrack/get_all_clients') do
          response = api_client.get_all_clients

          expect(response.success?).to eq(true)
          expect(response.payload).to be_a(Hash)
        end
      end

      it 'is a paginated request' do
        VCR.use_cassette('physitrack/get_all_clients') do
          expect(api_client).to receive(:get_all_clients).exactly(2).times.and_call_original
          api_client.get_all_clients
        end
      end
    end
  end # #get_all_clients

  describe '#create_client' do
    context 'successful request with valid params' do
      def valid_params
        {
          external_id: 'jane_app_id_123',
          first_name: 'John',
          last_name: 'Trevor',
          year_of_birth: 1990,
          gender: 'm',
          email: 'john@janeapp.com'
        }
      end

      it 'returns the response wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/create_client') do
          response = api_client.create_client(body: valid_params)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(201)
          expect(response.message).to  eq('Created')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'returns the newly created client in the payload' do
        VCR.use_cassette('physitrack/create_client') do
          response = api_client.create_client(body: valid_params)

          expect(response.payload['id']).to be_present
          expect(response.id).to be_present

          valid_params.each do |key, value|
            expect(response.payload).to include({ key.to_s => value })
          end
        end
      end
    end

    context 'unsuccessful request with invalid params' do
      it 'returns the failed response wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/create_client_failure') do
          response = api_client.create_client(body: {})

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(422)
          expect(response.message).to  eq('Unprocessable Entity')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/create_client_failure') do
          response = api_client.create_client(body: {})

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)

          EXPECTED_CLIENT_ERRORS.each do |error|
            expect(response.errors).to include(error)
          end
        end
      end
    end
  end # #create_client

  describe '#update_client' do
    context 'successful request with valid params' do
      def new_params
        {
          external_id: 'update_client-123',
          first_name: 'Geoff',
          last_name: 'Stalk',
          year_of_birth: 1968,
          gender: 'm',
          email: 'geoff@janeapp.com'
        }
      end

      it 'returns the response wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/update_client_success') do
          response = api_client.update_client(id: 7999, body: new_params)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'returns the newly updated client in the payload' do
        VCR.use_cassette('physitrack/update_client_success') do
          response = api_client.update_client(id: 7999, body: new_params)

          expect(response.payload['id']).to be_present
          expect(response.id).to be_present
          expect(response.id).to eq(7999)

          new_params.each do |key, value|
            expect(response.payload).to include({ key.to_s => value })
          end
        end
      end
    end

    context 'unsuccessful request with invalid params' do
      it 'returns the failed response wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/update_client_failure') do
          response = api_client.update_client(id: 7999, body: {})

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(422)
          expect(response.message).to  eq('Unprocessable Entity')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/update_client_failure') do
          response = api_client.update_client(id: 7999, body: {})

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)

          EXPECTED_CLIENT_ERRORS.each do |error|
            expect(response.errors).to include(error)
          end
        end
      end
    end
  end # #update_client

  describe '#find_client_program' do
    context 'successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_client_program_success') do
          response = api_client.find_client_program(client_id: 8224, access_code: 'ohidcced')

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'returns the correct client program' do
        VCR.use_cassette('physitrack/find_client_program_success') do
          response = api_client.find_client_program(client_id: 8224, access_code: 'ohidcced')

          expect(response.access_code).to eq('ohidcced')
        end
      end
    end

    context 'unsuccessful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_client_program_failure') do
          response = api_client.find_client_program(client_id: 8224, access_code: 'wrong_code')

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(404)
          expect(response.message).to  eq('Not Found')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/find_client_program_failure') do
          response = api_client.find_client_program(client_id: 8224, access_code: 'wrong_code')

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)

          expect(response.errors).to include('Program with given access code does not exist')
        end
      end
    end
  end # #find_client_program

  describe '#get_client_programs' do
    context 'successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_client_programs_success') do
          response = api_client.get_client_programs(client_id: 8224)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a programs key returns the correct number of programs' do
        VCR.use_cassette('physitrack/get_client_programs_success') do
          response = api_client.get_client_programs(client_id: 8224)

          expect(response.payload).to have_key('programs')
          expect(response.payload['programs']).to be_an(Array)
          expect(response.programs.length).to eq(1)
        end
      end
    end

    context 'unsuccessful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_client_programs_failure') do
          response = api_client.get_client_programs(client_id: 1234567)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(422)
          expect(response.message).to  eq('Unprocessable Entity')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/get_client_programs_failure') do
          response = api_client.get_client_programs(client_id: 1234567)

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)

          expect(response.errors).to include('Client with given id does not exist')
        end
      end
    end
  end # #get_client_programs

  describe '#assign_program' do
    context 'successful request' do
      def assign_program_body
        {
          template_id: 1148,
          external_id: "assign_program_id-123",
          start_date: Time.now.strftime('%Y-%m-%d'),
          num_weeks: 12,
          track_adherence: true,
          track_pain_levels: true
        }
      end

      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/assign_program_success') do
          response = api_client.assign_program(client_id: 7999, body: assign_program_body)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(201)
          expect(response.message).to  eq('Created')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'returns the program that was assigned in the payload' do
        VCR.use_cassette('physitrack/assign_program_success') do
          response = api_client.assign_program(client_id: 7999, body: assign_program_body)

          expect(response.payload).to be_present
          expect(response.payload['template_id']).to eq(1148)
        end
      end
    end

    context 'unsuccessful request' do
      def assign_program_errors
        [
          "template_id is missing",
          "start_date is missing",
          "start_date is not in ISO 8601 format (YYYY-MM-DDThh:mm:ssZ)"
        ]
      end

      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/assign_program_failure') do
          response = api_client.assign_program(client_id: 7999, body: {})

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(422)
          expect(response.message).to  eq('Unprocessable Entity')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/assign_program_failure') do
          response = api_client.assign_program(client_id: 7999, body: {})

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)

          assign_program_errors.each do |error|
            expect(response.errors).to include(error)
          end
        end
      end
    end
  end # #assign_program

  describe '#update_client_program' do
    context 'successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/update_client_program_success') do
          response = api_client.update_client_program(
            client_id:   7999,
            access_code: 'eesmsfqb',
            body:        { end_date: '2018-09-14' }
          )

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'returns the program that was assigned in the payload' do
        VCR.use_cassette('physitrack/update_client_program_success') do
          response = api_client.update_client_program(
            client_id:   7999,
            access_code: 'eesmsfqb',
            body:        { end_date: '2018-09-14' }
          )

          expect(response.payload).to be_present
          expect(response.payload['end_date']).to eq("2018-09-14T00:00:00Z")
        end
      end
    end
  end # #update_client_program

  describe '#resend_access_code' do
    context 'successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/resend_access_code') do
          response = api_client.resend_access_code(
            client_id:   7999,
            access_code: 'spimyean',
            via:         'email'
          )

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)

          # No payload is returned for a resend_access_code request
          expect(response.payload).to  be_empty
        end
      end
    end

    context 'unsuccessful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/resend_access_code') do
          response = api_client.resend_access_code(
            client_id:   7999,
            access_code: 'spimyean',
            via:         'sms'
          )

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(409)
          expect(response.message).to  eq('Conflict')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/resend_access_code') do
          response = api_client.resend_access_code(
            client_id:   7999,
            access_code: 'spimyean',
            via:         'sms'
          )

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)
          expect(response.errors).to include('Cannot send a sms to this client')
        end
      end
    end
  end # #resend_access_code

  describe '#get_client_program_exercises' do
    context '#successful request' do
      context 'JSON response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 7972, access_code: 'zppvoxgj')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(200)
            expect(response.message).to  eq('OK')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end


        it 'has a weeks key returns the correct number of weeks' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 7972, access_code: 'zppvoxgj')

            expect(response.payload).to have_key('schedule_type')
            expect(response.payload['schedule_type']).to eq('weekly')
            expect(response.payload).to have_key('weeks')
            expect(response.payload['weeks']).to be_an(Array)
            expect(response.weeks.all? { |w| w.is_a?(Hash) }).to eq(true)
          end
        end
      end

      context 'PDF response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 7972, access_code: 'zppvoxgj', pdf: true)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(202)
            expect(response.message).to  eq('Accepted')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end


        it 'has a url key and returns a valid url' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 7972, access_code: 'zppvoxgj', pdf: true)

            expect(response.payload).to have_key('url')
            expect(response.payload['url']).to be_a(String)
            expect(response.url).to include('https://physitrackuploads.s3.amazonaws.com/pdfs')
          end
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 12345, access_code: 'zppvoxgj')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 12345, access_code: 'zppvoxgj')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad access_code' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 12345, access_code: 'nah_son')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_client_program_exercises') do
            response = api_client.get_client_program_exercises(client_id: 7999, access_code: 'zppvoxgj')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Program with given access code does not exist')
          end
        end
      end
    end
  end # #get_client_program_exercises

  describe '#get_client_program_adherence' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_client_program_adherence') do
          response = api_client.get_client_program_adherence(client_id: 7972, access_code: 'zppvoxgj')

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end


      it 'has a days key which is an Array' do
        VCR.use_cassette('physitrack/get_client_program_adherence') do
          response = api_client.get_client_program_adherence(client_id: 7972, access_code: 'zppvoxgj')

          expect(response.payload).to have_key('avg_adherence')
          expect(response.payload).to have_key('days')
          expect(response.days).to be_an(Array)
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_adherence') do
            response = api_client.get_client_program_adherence(client_id: 12345, access_code: 'zppvoxgj')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_client_program_adherence') do
            response = api_client.get_client_program_adherence(client_id: 12345, access_code: 'zppvoxgj')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad access_code' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_client_program_adherence') do
            response = api_client.get_client_program_adherence(client_id: 12345, access_code: 'nah_son')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_client_program_adherence') do
            response = api_client.get_client_program_adherence(client_id: 7999, access_code: 'zppvoxgj')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Program with given access code does not exist')
          end
        end
      end
    end
  end # #get_client_program_adherence

  describe '#find_client_program_prom_results' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_client_program_prom_results') do
          response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'enyjeaor', id: 2166)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a proms key which contains all the proms in an Array' do
        VCR.use_cassette('physitrack/find_client_program_prom_results') do
          response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'enyjeaor', id: 2166)

          expect(response.payload).to have_key('results')
          expect(response.results).to be_an(Array)
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad client id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 12345, access_code: 'enyjeaor', id: 2166)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 12345, access_code: 'enyjeaor', id: 2166)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad access_code' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'nah_son', id: 2166)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'nah_son', id: 2166)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Program with given access code does not exist')
          end
        end
      end

      context 'bad prom id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'enyjeaor', id: 5253)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom_results') do
            response = api_client.find_client_program_prom_results(client_id: 8205, access_code: 'enyjeaor', id: 5253)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('PROM with given id does not exist')
          end
        end
      end
    end
  end # #find_client_program_prom_results

  describe '#get_all_client_program_proms' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_client_program_proms') do
          response = api_client.get_all_client_program_proms(client_id: 8205, access_code: 'enyjeaor')

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a proms key which contains all the proms in an Array' do
        VCR.use_cassette('physitrack/get_all_client_program_proms') do
          response = api_client.get_all_client_program_proms(client_id: 8205, access_code: 'enyjeaor')

          expect(response.payload).to have_key('proms')
          expect(response.proms).to be_an(Array)
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad client id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_all_client_program_proms') do
            response = api_client.get_all_client_program_proms(client_id: 12345, access_code: 'enyjeaor')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_all_client_program_proms') do
            response = api_client.get_all_client_program_proms(client_id: 12345, access_code: 'enyjeaor')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad access_code' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_all_client_program_proms') do
            response = api_client.get_all_client_program_proms(client_id: 8205, access_code: 'nah_son')

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_all_client_program_proms') do
            response = api_client.get_all_client_program_proms(client_id: 8205, access_code: 'nah_son')

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Program with given access code does not exist')
          end
        end
      end
    end
  end # #get_all_client_program_proms

  describe '#find_client_program_prom' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_client_program_prom') do
          response = api_client.find_client_program_prom(client_id: 8205, access_code: 'enyjeaor', id: 2166)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a name description questions keys that contain the prom data' do
        VCR.use_cassette('physitrack/find_client_program_prom') do
          response = api_client.find_client_program_prom(client_id: 8205, access_code: 'enyjeaor', id: 2166)

          expect(response.payload.keys).to eq(%w(name description questions))
          expect(response.questions).to be_an(Array)
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad client id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 12345, access_code: 'enyjeaor', id: 2166)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 12345, access_code: 'enyjeaor', id: 2166)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad access_code' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 8205, access_code: 'nah_son', id: 2166)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 8205, access_code: 'nah_son', id: 2166)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Program with given access code does not exist')
          end
        end
      end

      context 'bad prom id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 8205, access_code: 'enyjeaor', id: 5253)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_program_prom') do
            response = api_client.find_client_program_prom(client_id: 8205, access_code: 'enyjeaor', id: 5253)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('PROM with given id does not exist')
          end
        end
      end
    end
  end # #find_client_program_prom

  describe '#get_all_client_messages' do
    context '#successful request' do
      context 'JSON response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_all_client_messages') do
            response = api_client.get_all_client_messages(client_id: 7972)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(200)
            expect(response.message).to  eq('OK')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a messages key which contains hashes' do
          VCR.use_cassette('physitrack/get_all_client_messages') do
            response = api_client.get_all_client_messages(client_id: 7972)

            expect(response.payload).to have_key('messages')
            expect(response.payload['messages']).to be_an(Array)
            expect(response.messages.all? { |w| w.is_a?(Hash) }).to eq(true)
          end
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad client id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/get_all_client_messages') do
            response = api_client.get_all_client_messages(client_id: 12345)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(422)
            expect(response.message).to  eq('Unprocessable Entity')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/get_all_client_messages') do
            response = api_client.get_all_client_messages(client_id: 12345)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end
    end
  end # #get_all_client_messages

  describe '#find_client_message' do
    context '#successful request' do
      context 'JSON response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 8205, id: 15330)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(200)
            expect(response.message).to  eq('OK')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'returns the correct message with matching id' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 8205, id: 15330)

            expect(response.payload).to have_key('id')
            expect(response.id).to eq('15330')
          end
        end
      end
    end

    context 'unsuccessful request' do
      context 'bad client id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 12345, id: 15330)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 12345, id: 15330)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Client with given id does not exist')
          end
        end
      end

      context 'bad message id' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 8205, id: 12345)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(404)
            expect(response.message).to  eq('Not Found')
            expect(response.status).to   eq(false)
            expect(response.success?).to eq(false)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'has a payload and that contains an errors Hash' do
          VCR.use_cassette('physitrack/find_client_message') do
            response = api_client.find_client_message(client_id: 8205, id: 12345)

            expect(response.payload).to be_a(Hash)
            expect(response.payload).to have_key('errors')
            expect(response.respond_to?('errors')).to be(true)
            expect(response.errors).to include('Message with given id does not exist')
          end
        end
      end
    end
  end # #find_client_message

  describe '#find_template' do
    context '#successful request' do
      context 'JSON response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_template') do
            response = api_client.find_template(id: 27539)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(200)
            expect(response.message).to  eq('OK')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'returns the correct template with matching id' do
          VCR.use_cassette('physitrack/find_template') do
            response = api_client.find_template(id: 27539)

            expect(response.payload).to have_key('id')
            expect(response.id).to eq(27539)
          end
        end
      end
    end

    context 'unsuccessful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_template') do
          response = api_client.find_template(id: 12345)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(404)
          expect(response.message).to  eq('Not Found')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/find_template') do
          response = api_client.find_template(id: 12345)

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)
          expect(response.errors).to include('Template with given id does not exist')
        end
      end
    end
  end # #find_template

  describe '#get_all_templates' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_templates') do
          response = api_client.get_all_templates

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

     it 'is a paginated request' do
        VCR.use_cassette('physitrack/get_all_templates') do
          expect(api_client).to receive(:get_all_templates).exactly(1).times.and_call_original
          api_client.get_all_templates
        end
      end

      it 'has a templates key which contains hashes' do
        VCR.use_cassette('physitrack/get_all_templates') do
          response = api_client.get_all_templates

          expect(response.payload).to have_key('templates')
          expect(response.payload['templates']).to be_an(Array)
          expect(response.templates.all? { |w| w.is_a?(Hash) }).to eq(true)
        end
      end

      it 'returns the correct number of templates' do
        VCR.use_cassette('physitrack/get_all_templates') do
          response = api_client.get_all_templates

          expect(response.payload).to have_key('templates')
          expect(response.payload['templates']).to be_an(Array)
          expect(response.templates.count).to eq(189)
        end
      end
    end
  end # #get_all_templates

  describe '#find_event' do
    context '#successful request' do
      context 'JSON response' do
        it 'returns the client wrapped in a physitrack response object' do
          VCR.use_cassette('physitrack/find_event') do
            response = api_client.find_event(id: 2330)

            expect(response).to          be_a(PhysitrackApi::Response)
            expect(response.code).to     eq(200)
            expect(response.message).to  eq('OK')
            expect(response.status).to   eq(true)
            expect(response.success?).to eq(true)
            expect(response.payload).to  be_a(Hash)
          end
        end

        it 'returns the correct event with matching id' do
          VCR.use_cassette('physitrack/find_event') do
            response = api_client.find_event(id: 2330)

            expect(response.payload).to have_key('id')
            expect(response.id).to eq(2330)
          end
        end
      end
    end

    context 'unsuccessful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/find_event') do
          response = api_client.find_event(id: 12345)

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(404)
          expect(response.message).to  eq('Not Found')
          expect(response.status).to   eq(false)
          expect(response.success?).to eq(false)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a payload and that contains an errors Hash' do
        VCR.use_cassette('physitrack/find_event') do
          response = api_client.find_event(id: 12345)

          expect(response.payload).to be_a(Hash)
          expect(response.payload).to have_key('errors')
          expect(response.respond_to?('errors')).to be(true)
          expect(response.errors).to include('Event with given id does not exist')
        end
      end
    end
  end # #find_event

  describe '#get_all_events' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_events') do
          response = api_client.get_all_events

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'is a paginated request' do
        VCR.use_cassette('physitrack/get_all_events') do
          expect(api_client).to receive(:get_all_events).exactly(2).times.and_call_original
          api_client.get_all_events
        end
      end

      it 'has a events key which contains hashes' do
        VCR.use_cassette('physitrack/get_all_events') do
          response = api_client.get_all_events

          expect(response.payload).to have_key('events')
          expect(response.payload['events']).to be_an(Array)
          expect(response.events.all? { |w| w.is_a?(Hash) }).to eq(true)
        end
      end

      it 'returns the correct number of events' do
        VCR.use_cassette('physitrack/get_all_events') do
          response = api_client.get_all_events

          expect(response.payload).to have_key('events')
          expect(response.payload['events']).to be_an(Array)
          expect(response.events.count).to eq(288)
        end
      end
    end
  end # #get_all_events

  describe '#get_all_exercises' do
    context '#successful request' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'is a paginated request' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          expect(api_client).to receive(:get_all_exercises).exactly(18).times.and_call_original
          api_client.get_all_exercises
        end
      end

      it 'has a exercises key which contains hashes' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises

          expect(response.payload).to have_key('exercises')
          expect(response.payload['exercises']).to be_an(Array)
          expect(response.exercises.all? { |w| w.is_a?(Hash) }).to eq(true)
        end
      end

      it 'returns the correct number of exercises' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises

          expect(response.payload).to have_key('exercises')
          expect(response.payload['exercises']).to be_an(Array)
          expect(response.exercises.count).to eq(3501)
        end
      end
    end

    context 'with optional query param' do
      it 'returns the client wrapped in a physitrack response object' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises(query: 'stabilisation')

          expect(response).to          be_a(PhysitrackApi::Response)
          expect(response.code).to     eq(200)
          expect(response.message).to  eq('OK')
          expect(response.status).to   eq(true)
          expect(response.success?).to eq(true)
          expect(response.payload).to  be_a(Hash)
        end
      end

      it 'has a exercises key which contains hashes' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises(query: 'stabilisation')

          expect(response.payload).to have_key('exercises')
          expect(response.payload['exercises']).to be_an(Array)
          expect(response.exercises.all? { |w| w.is_a?(Hash) }).to eq(true)
        end
      end

      it 'returns the correct number of exercises' do
        VCR.use_cassette('physitrack/get_all_exercises') do
          response = api_client.get_all_exercises(query: 'stabilisation')

          expect(response.payload).to have_key('exercises')
          expect(response.payload['exercises']).to be_an(Array)
          expect(response.exercises.count).to eq(39)
        end
      end
    end
  end # #get_all_exercises
end
