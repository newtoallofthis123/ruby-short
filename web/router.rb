# frozen_string_literal: true

require_relative 'http'
require 'json'

# Router routes stuff
class Router
  def initialize(req, db)
    @req = req
    @db = db
    @index = {
      '/' => { 'GET' => 'get' },
      '/insert' => { 'POST' => 'insert' }
    }
    @dir = Dir.new @req, @db
  end

  # Responds with an HTTP response that is delegated to Dir or a 404
  def respond
    # This handles the actual url redirection
    return [@dir.send('get'), 302] unless @index.key?(@req.path)

    # If method is not found for a particular entry
    return [@dir.send('not_found'), 404] unless @index[@req.path].key?(@req.method)

    [@dir.send(@index[@req.path][@req.method]), 200]
  end
end

# The Websites Directory
class Dir
  def initialize(req, db)
    @req = req
    @db = db
  end

  private

  def generate_random(length = 6)
    pool = 'abcdefghijklmnopqrstuvwxyz1234567890'.chars
    pool.sample(length).join('')
  end

  def insert
    begin
      content = Hash[JSON.parse(@req.content)]
    rescue JSON::ParserError
      return HttpResponse.new('Json ParserError', 500).construct
    end
    return HttpResponse.new('No Url specified', 500).construct unless content['url']

    HttpResponse.new(@db.insert(content['id'] || generate_random, content['url'], Time.now.to_s)).construct
  end

  def get
    id = @req.path[1..]

    row = @db.get(id)
    unless row == false
      return HttpResponse.new('Redirecting', 302, status_message: 'Found',
                                                  headers: { 'Location' => row[1] }).construct
    end

    HttpResponse.new('404',  404).construct
  end

  def hello
    HttpResponse.new('Hello! exp v.0.1').construct
  end

  def not_found
    HttpResponse.new('404 Error', 404).construct
  end
end
