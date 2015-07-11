#
# The MIT License (MIT)
#
# Copyright (c) 2014 Evgeny Shurakov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

require 'digest/md5'
require 'rest_client'

module Locca
    class Onesky

    	def initialize(project_id, public_key, secret_key)
    		@project_id = project_id
            @public_key = public_key
            @secret_key = secret_key
        end

        def upload_file(file_path, file_format, deprecate_missing_strings = false)
            fetch_response(:post, "files", {'file' => File.new(file_path), 'file_format' => file_format, 'is_keeping_all_strings' => !deprecate_missing_strings})
        end

        def fetch_translations(lang, file_name)
            return fetch_response(:get, "translations", {'locale' => lang, 'source_file_name' => file_name})
        end

        def authorization_params
            timestamp = Time.now.to_i.to_s
            {:"api_key" => @public_key, :timestamp => timestamp, :"dev_hash" => Digest::MD5.hexdigest(timestamp + @secret_key)}
        end

        def fetch_response(http_verb, path, params)
            options = {:content_type => "application/json; charset=UTF-8", :accept => "application/json"}
            params = authorization_params.merge(params)
            
            path = "https://platform.api.onesky.io/1/projects/#{@project_id}/#{path}"

            response = case http_verb
            when :get
                RestClient.get(path, {:params => params}.merge(options))
            when :post
                RestClient.post(path, params.merge(options))
            else
                raise "bad http verb"
            end

            return response
        end

    end
end
