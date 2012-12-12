require 'uri'
require 'net/http'
require 'json'

module Sensu
    class API
        def initialize(server_uri)
            @server_uri = URI(server_uri)
        end

        def silence_node(node_id, payload={})
            req = Net::HTTP::Post.new("/stash/silence/#{node_id}",
                {'Content-Type' => 'application/json'})

            payload = payload.merge({
                'timestamp' => Time.now.to_i,
                'actor' => 'chef'
            }).to_json

            req.body = payload

            Net::HTTP.start(@server_uri.host, @server_uri.port) do |http|
                http.request(req)
            end
        end

        def unsilence_node(node_id)
            req = Net::HTTP::Delete.new("/stash/silence/#{node_id}")
            Net::HTTP.start(@server_uri.host, @server_uri.port) do |http|
                http.request(req)
            end
        end
    end
end
