# frozen_string_literal: true

require 'json'

module IcontrolRest
  # A iControl REST Client for retrieving data from F5s.
  class Client
    include Utils::Logging
    include HTTParty
    format :json

    # A client used to interact with a devices iControl API. Turns method calls into REST commands.
    #
    # host        - The ip or hostname of the host we're trying to reach as a string
    # user        - The username of the account we're connecting with as a string.
    # pass        - the pass of the account we're connecting with.
    # verify_cert - Boolean of whether we want to check certificates.
    # timeout     - Integer of seconds we want the timeout to be set to.
    # sleep       - Number of seconds to sleep after an icontrol call.
    #
    # Examples
    #
    #   api = IcontrolRest::Client.new(host: '1.2.3.4', user: 'user', pass: 'pass', verify_cert: false)
    #   # => #<IcontrolRest::Client:0x007fb953ab7750 @options={ ... }>
    #
    #   api.get_sys_dns
    #   # => {"kind"=>"tm:sys:dns:dnsstate",
    #         "selfLink"=>"https://localhost/mgmt/tm/sys/dns?ver=11.5.4",
    #         "description"=>"configured-by-dhcp",
    #         "nameServers"=>["1.2.3.72", "1.2.3.73"],
    #         "search"=>["domain.com"]}
    #
    # rubocop:disable Metrics/ParameterLists
    def initialize(host:, pass:, user:, timeout: 100, verify_cert: true, sleep: 0, tries: 1)
      self.class.base_uri "https://#{host}"
      @sleep = sleep.to_i
      @tries = tries.to_i
      @options = { basic_auth: { username: user, password: pass }, headers: { 'Content-Type' => 'application/json' },
                   verify: verify_cert, timeout: timeout }
      @retry_handler = proc do |exception, try, _elapsed_time, _next_interval|
        logger.error { "#{exception.class}: #{exception.message} - try #{try}" }
        if exception.instance_of?(JSON::ParserError)
          logger.info { "F5 configuration utility not ready to proceed, sleeping '30' seconds." }
          sleep 30
        end
      end
    end
    # rubocop:enable Metrics/ParameterLists

    # Public    - Delete/Get request method.
    #
    # route     - URI to send to server as a string.
    # headers   - Hash of headers to pass with request.
    #
    # Returns   - response from the server as a hash.
    #
    # Examples
    #
    #   api.get('/mgmt/tm/sys/dns')
    #   # => {"kind"=>"tm:sys:dns:dnsstate",
    #         "selfLink"=>"https://localhost/mgmt/tm/sys/dns?ver=11.5.4",
    #         "description"=>"configured-by-dhcp",
    #         "nameServers"=>["1.2.3.72", "1.2.3.73"],
    #         "search"=>["domain.com"]}
    #
    %w[delete get].each do |action|
      define_method(action.to_s) do |route, headers: {}|
        send_request(action: action, route: route, headers: headers)
      end
    end

    # Public    - Post/Put/Patch request methods.
    #
    # route     - URI to send to server as a string.
    # body      - Hash representing the request body.
    # headers   - Hash of headers to pass with request.
    #
    # Returns   - response from the server as a hash.
    %w[post put patch].each do |action|
      define_method(action.to_s) do |route, body: {}, headers: {}|
        send_request(action: action, route: route, body: body, headers: headers)
      end
    end

    private

    # Private - Handles response and raises error if the response isn't a 200.
    #
    # action  - The HTTP action being executed.
    # route   - The route to send the request to.
    # headers - A Hash representing any headers to be passed with the request.
    # body    - A Hash representing the request body to be passed with the request.
    #
    # Returns - response from the server as a hash.
    #
    # Raises  - RuntimeError when the server returns a response that isn't a 200
    def send_request(action:, route:, headers: {}, body: nil)
      Retriable.retriable on_retry: @retry_handler, tries: @tries do
        body = body.to_json unless body.nil?
        response = self.class.send(action, route, @options.deep_merge(body: body, headers: headers))
        sleep(@sleep) if @sleep.positive?
        return response if response.code == 200

        raise "#{response['code']}: #{response['message']}"
      end
    end

    # Private     - Converts a missing method into a REST request.
    #
    # method_name - Symbol of unknown method called.
    # *args       - An array of arguments passed with the method call.
    #
    # Returns     - Response from the method called.
    def method_missing(method_name, **args)
      super unless respond_to_missing?(method_name)
      route_chain = method_name.to_s.split('_')
      send(route_chain[0].downcase, route(route_chain), args)
    end

    # Private     - Adds methods prefixed with delete/get/post/put/patch to object.
    #
    # method_name - Symbol of unknown method called.
    #
    # Returns     - true if the object responds to it, or if delete/get..etc.
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?('delete', 'get', 'post', 'put', 'patch') || super
    end

    # Private     - Converts the route chain into a uri.
    #
    # route_chain - An array of route chain.
    #
    # Returns     - A URI as a string.
    def route(route_chain)
      raise 'Empty route chain.' if route_chain.length <= 1

      "/mgmt/tm/#{route_chain[1..route_chain.length].join('/')}"
    end
  end
end
