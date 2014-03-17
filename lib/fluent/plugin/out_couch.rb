module Fluent
	class CouchOutput < BufferedOutput
		include SetTagKeyMixin
		config_set_default :include_tag_key, false

		include SetTimeKeyMixin
		config_set_default :include_time_key, true

		Fluent::Plugin.register_output('couch', self)

		config_param :database, :string

		config_param :host, :string, :default => 'localhost'
		config_param :port, :string, :default => '5984'
		config_param :protocol, :string, :default => 'http'

		config_param :refresh_view_index, :string, :default => nil

		config_param :user, :string, :default => nil
		config_param :password, :string, :default => nil

		config_param :update_docs, :bool, :default => false
		config_param :doc_key_field, :string, :default => nil
		config_param :doc_key_jsonpath, :string, :default => nil
		config_param :db_key, :string, :default => nil
		config_param :db_per, :string, :default => nil
		#
		#
		def initialize
			super

			require 'msgpack'
			require 'jsonpath'
			Encoding.default_internal = 'UTF-8'
			require 'couchrest'
			Encoding.default_internal = 'ASCII-8BIT'
		end
		#
		#
		def configure(conf)
			super
		end
		#
		#
		def start
			super

			if @db_key or @db_per
				raise "update_docs is not compatible with db_key or db_per yet!" if @update_docs
				raise "refresh_view_index is not compatible with db_key or db_per yet!" if @refresh_view_index
			end

			@account = "#{@user}:#{@password}@" if @user && @password

			@db = {}

			#
			# todo : doesn't work
			#
			if @db_per and @db_key
				@write = self.method :write_by_key_per
			elsif @db_per
				raise "todo: do not currenty support db_per without db_key"
			elsif @db_key
				@write = self.method :write_by_key
			else
				@write = self.method :write_default
			end

			if not @db_key or @db_per
				@db[:default] = CouchRest.database!("#{@protocol}://#{@account}#{@host}:#{@port}/#{@database}")
			end

			@views = []

			if @refresh_view_index
				begin
					@db[:default].get("_design/#{@refresh_view_index}")['views'].each do |view_name, func|
						@views.push([@refresh_view_index, view_name])
					end
				rescue
					$log.error 'design document not found!'
				end
			end
		end
		#
		#
		def shutdown
			super
		end
		#
		#
		def format(tag, time, record)
			record.to_msgpack
		end
		#
		# todo : this sucks
		#
		def write(chunk)
			if @db_per and @db_key
				write_by_key_per chunk
			elsif @db_per
				raise "todo: do not currenty support db_per without db_key"
			elsif @db_key
				write_by_key chunk
			else
				write_default chunk
			end
		end
		def write_default(chunk)
			records = []

			chunk.msgpack_each do |record|

				id = record[@doc_key_field]
				id = JsonPath.new(@doc_key_jsonpath).first(record) if id.nil? && !@doc_key_jsonpath.nil?
				record['_id'] = id unless id.nil?
				records << record
			end

			if @update_docs
				update_docs(records)
			else
				@db[:default].bulk_save(records)
			end

			update_view_index
		end
		#
		#
		def write_by_key_per(chunk)
			records = {}

			chunk.msgpack_each do |record|
				id = record[@doc_key_field]
				id = JsonPath.new(@doc_key_jsonpath).first(record) if id.nil? && !@doc_key_jsonpath.nil?
				record['_id'] = id unless id.nil?

				date = record['dt']
				key = "#{record[@db_key]}_#{date[0]}#{date[1]}#{date[2]}"

				records[key] = [] unless records[key]
				records[key] << record
			end

			records.each_pair do |key, data|
				if not @db[key]
					@db[key] = CouchRest.database!("#{@protocol}://#{@account}#{@host}:#{@port}/#{@database+"_"+key}")
				end

				@db[key].bulk_save(data)
			end

		end
		#
		#
		def write_by_key(chunk)
			records ={}

			chunk.msgpack_each do |record|
				id = record[@doc_key_field]
				id = JsonPath.new(@doc_key_jsonpath).first(record) if id.nil? && !@doc_key_jsonpath.nil?
				record['_id'] = id unless id.nil?

				key =  record[@db_key]
				records[key] = [] unless records[key]
				records[key] << record
			end

			records.each_pair do |key, data|
				if not @db[key]
					@db[key] = CouchRest.database!("#{@protocol}://#{@account}#{@host}:#{@port}/#{@database+"_"+key}")
				end

				@db[key].bulk_save(data)
			end

		end
		#
		#
		def update_docs(records)

			if records.length > 0
				records.each do |record|
					doc = nil

					begin
						doc = @db[:default].get(record['_id'])
					rescue
					end

					record['_rev']=doc['_rev'] unless doc.nil?
					$log.debug record
					@db[:default].save_doc(record)
				end
			end
		end
		#
		#
		def update_view_index()
			@views.each do |design, view|
				@db[:default].view("#{design}/#{view}", {'limit' => '0'})
			end
		end
	end
end
