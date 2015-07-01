class ApiTalk

  include HTTParty

  class << self

    def get(url, options = {}, return_object = nil)
      puts (url)
      resultset({}, {})
      #submit_request(url, :post, 'get', options, return_object)
    end

    private

      def resultset(response, return_object)
        puts '+ +' * 10
      end


      def create_response(http_code, results={}, options={})
        api_code = results["status"]["code"]
        attrs = {
          code:   http_code,
          status: results["status"],
          data:   results["return_object"],
          api_code: api_code
        }.merge(:extras => options)
        ApiResponse.new(attrs)
      end

      def submit_request(url, request_type, headers_param, options = {}, return_object = nil, multipart_options = nil)
        if(multipart_options)
          response = HTTMultiParty.send request_type, API_URL + "#{url}",
                      headers: headers(headers_param),
                      query: add_security_token(multipart_options),
                      detect_mime_type: true
        else
          response = HTTParty.send request_type, API_URL + "#{url}",
                      body: JSON.dump(add_security_token(options)),
                      headers: headers(headers_param)
        end
        raise "API-ERROR-401" if response.code==401
        results  = resultset(response.parsed_response, return_object || url)
        create_response(response.code, results)
      end

  end
end

