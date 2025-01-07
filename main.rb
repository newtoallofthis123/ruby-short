# frozen_string_literal: true

require 'socket'
require_relative 'web/http'
require_relative 'web/router'
require_relative 'web/db'

s = TCPServer.new 6969
puts 'Binded to :6969'

db = Db.new

loop do
  Thread.start(s.accept) do |client|
    req = HttpRequest.new(client)

    router = Router.new(req, db)

    res, status = router.respond

    client.puts res
    puts "#{status} for #{req.method} #{req.path} at #{Time.now}"

    client.close
  end
end
