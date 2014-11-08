# -*- coding:utf-8 -*-
require 'ppc/api/qihu/account'
require 'ppc/api/qihu/plan'
require 'ppc/api/qihu/group'
require 'ppc/api/qihu/keyword'
require 'ppc/api/qihu/creative'
require 'httparty'
require 'json'

module PPC
  module API
    class Qihu

      def self.request( auth, service, method, params = {} )
        url = "https://api.e.360.cn/2.0/#{service}/#{method}"
        # 日后考虑将httpparty用Net/http代替
        response = HTTParty.post(url, 
                body: params,
                headers: {'apiKey' => auth[:token], 
                                'accessToken' => auth[:accessToken], 
                                'serveToken' => Time.now.to_i.to_s  }
              )

        response.parsed_response
      end

      def self.process( response, key, failure_key = '', &func )
        p response
        response_key = response.keys[0]
        content = response[ response_key ]
        # special case solution
        if content == nil
          return{ succ:true, failure:nil, result:nil }
        end

        result = { }
        if content['failures'] != nil
          result[:succ] = false
          result[:failure] = content['failures']['item']
          result[:result] = content[ key ]
        else
          result[:succ] = true
          result[:result] = func[ key==''? content : content[ key ] ]
          result[:failure] = failure_key == ''? nil : content[ failure_key ]
        end
        return result
      end

      def self.to_json_string( ids )
        '''
        convert list of string/int to list of json string
        '''
        return '' if ids == nil
        ids = [ids] unless ids.is_a? Array
        ids_str = []
        ids.each{ |x| ids_str << x.to_s }
        ids_str.to_json
      end

      def self.to_id_list( ids_str )
        return [] if ids_str == nil
        ids_str = [ids_str] unless ids_str.is_a? Array
        ids_i = []
        ids_str.each{ |id| ids_i<<id.to_i }
        ids_i
      end

      def self.make_type( params, map = @map)
        '''
        '''
        params = [ params ] unless params.is_a? Array

        types = []
        params.each do |param|
          type = {}

            map.each do |key|
              value = param[ key[0] ]
              type[ key[1] ] = value if value != nil
            end

          types << type
        end
        return types
      end

      def self.reverse_type( types, map = @map )
        '''
        '''
        types = [ types ] unless types.is_a? Array

        params = []
        types.each do |type|
          param = {}
          
            map.each do |key|
                value = type[ key[1].to_s ]
                param[ key[0] ] = value if value != nil
            end

          params << param
        end
        return params
      end

    end
  end
end