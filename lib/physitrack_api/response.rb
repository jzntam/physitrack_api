module PhysitrackApi
  class Response
    attr_reader :payload, :status, :code, :message

    def self.from(http_response, payload: nil)
      payload = payload || http_response.to_h
      status  = http_response.success?
      code    = http_response.code
      message = http_response.message

      new(payload: payload, status: status, code: code, message: message)
    end

    def initialize(payload:, status:, code:, message:)
      @payload = payload
      @status  = status
      @code    = code
      @message = message
    end

    def success?
      @status
    end

    def attributes
      @payload.keys
    end

    def method_missing(method_name, *args, &block)
      return super unless @payload.is_a?(Hash)

      if @payload.has_key?(method_name.to_s)
        @payload.fetch(method_name.to_s)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      return super unless @payload.is_a?(Hash)

      @payload.has_key?(method_name.to_s) || super
    end
  end
end
