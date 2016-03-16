#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/https'
require 'net/imap'
require 'yaml'
require 'json'
require 'pry'

yaml  = YAML.load_file 'config.yaml'
SLACK = yaml['slack']
MAIL  = yaml['mail']

def post json
  uri = URI.parse SLACK['webhook']
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    req = Net::HTTP::Post.new uri
    req.body = "payload=#{json.to_s}"
    http.request req
  end
end

imap = Net::IMAP.new(MAIL['server'], ssl: {verify_mode: OpenSSL::SSL::VERIFY_PEER})
imap.authenticate('PLAIN', MAIL['user'], MAIL['password'])
imap.examine(MAIL['folder'])
#imap.idle do |mail|
  #binding.pry
#end

message = {"text": "test"}
post(JSON[message])
