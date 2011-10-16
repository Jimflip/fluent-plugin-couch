
module Couch
    require 'net/http'
    class Server
        def initialize(host, port, options = nil)
            @host = host
            @port = port
            @options = options
        end

        def delete(uri)
            request(Net::HTTP::Delete.new(uri))
        end

        def get(uri)
            request(Net::HTTP::Get.new(uri))
        end

        def put(uri, json)
            req = Net::HTTP::Put.new(uri)
            req["content-type"] = "application/json"
            req.body = json
            request(req)
        end

        def post(uri, json)
            req = Net::HTTP::Post.new(uri)
            req["content-type"] = "application/json"
            req.body = json
            request(req)
        end

        def request(req)
            res = Net::HTTP.start(@host, @port) { |http|http.request(req) }
            res
        end

    end
end

module Fluent
    class CouchOutput < BufferedOutput
        
        include SetTagKeyMixin
        config_set_default :include_tag_key, false

        include SetTimeKeyMixin
        config_set_default :include_time_key, true

        Fluent::Plugin.register_output('couch', self)
        
        config_param :database, :string => nil do |val|
            '/'+val
        end
        config_param :host, :string, :default => 'localhost'
        config_param :port, :string, :default => '5984'

        def initialize
            super
            require 'msgpack'
        end

        def configure(conf)
            super
        end

        def start
            super
            @couch = Couch::Server.new(@host, @port)
            @couch.put(@database, "")
        end

        def shutdown
            super
        end

        def format(tag, time, record)
            record.to_msgpack
        end

        def write(chunk)
            records = []
            chunk.msgpack_each {|record| records << record }
            @couch.post(@database+'/_bulk_docs', {"all_or_nothing"=>true, "docs"=>records}.to_json)

            #for record in records
            #    @couch.post(@database,record.to_json)
            #end
        end
    end
end
