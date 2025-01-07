# frozen_string_literal: true

# HttpResponse
class HttpResponse
  def initialize(message, status_code = 200, headers: {}, status_message: 'OK')
    @status_code = status_code.to_s
    @status_message = status_message
    @message = message
    @headers = headers
    @headers['Content-Type'] = 'text/plain' unless @headers['Content-Type']
  end

  def construct
    s = 'HTTP/1.1 '
    s += @status_code
    s += " #{@status_message}\n"

    @headers.each_key do |key|
      s += "#{key}: #{@headers[key]}\n"
    end
    # Add the content length header
    s += "Content-Length: #{@message.length}\n"

    s += "\n#{@message}\r\r"
    s
  end
end

# HttpRequest
class HttpRequest
  attr_reader :method, :path, :protocol, :headers, :content

  def initialize(client)
    @client = client
    @method, @path, @protocol = parse_info
    @headers = parse_headers
    @content = parse_content
  end

  private

  def parse_info
    req_line = @client.gets
    method, path, protocol = req_line.strip.split(' ')
    [method, path, protocol]
  end

  def parse_headers
    headers = {}
    while (line = @client.gets)
      break if line.strip.empty?

      key, value = line.strip.split(': ', 2)
      headers[key] = value
    end

    headers
  end

  def parse_content
    body = false
    content_length = headers['Content-Length'].to_i
    body = @client.read(content_length) if content_length.positive?
    body
  end
end
