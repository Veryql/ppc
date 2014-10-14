# -*- coding:utf-8  -*-
module PPC
  module API
    module Baidu
      module Group
        include ::PPC::API::Baidu
        Service = 'Adgroup'

        # introduce request to this namespace
        def self.request(auth, service, method, params = {} )
          ::PPC::API::Baidu::request(auth, service, method, params )
        end

        def self.all(auth, test = false )
          """
          @return : Array of campaignAdgroupIds
          """
          response = request( auth, Service , "getAllAdgroupId" )
          return response if test else response['body']["campaignAdgroupIds"]
        end

        def self.add( auth, groups, test = false )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_adgrouptype( groups )

          body = {adgroupTypes:  adgrouptypes }
          
          response = request( auth, Service, "addAdgroup", body  )
          return response if  test else  response['body']['adgroupTypes'] 
        end

        def self.update( auth, groups, test = false )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_adgrouptype( groups )
          body = {adgroupTypes: adgrouptypes}
          
          response = request( auth, Service, "updateAdgroup",body )
          return response if test else  response['body']['adgroupTypes']
        end

        def self.delete( auth, ids, test = false )
          """
          目前没办法返回header
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }

          response = request( auth, Service,"deleteAdgroup", body )
          if !test
            return response[ 'header' ][ 'desc' ] == 'success'
          else 
            return response
          end
        end

        def self.search_by_plan_id( auth, ids, test = false )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, Service ,"getAdgroupByCampaignId",  body )
          return response if test else response['body']["campaignAdgroups"]
        end

        def self.search_by_group_id( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }
          response = request(auth, Service, "getAdgroupByAdgroupId",body )
          return response if test else response['body']["adgroupTypes"]
        end

        private
        def self.make_adgrouptype( params )
            params = [ params ] unless params.is_a? Array
            adgrouptypes = []

            params.each{  | param | 
              adgrouptype = {}

              adgrouptype[:campaignId]                  =   param[:plan_id]                 if    param[:plan_id] 
              adgrouptype[:adgroupId]                    =   param[:id]                           if    param[:id] 
              adgrouptype[:adgroupName]             =   param[:name]                    if    param[:name] 
              adgrouptype[:maxPrice]                      =   param[:price]                     if    param[:price] 
              adgrouptype[:negativeWords]            =   param[:negative]               if    param[:negative]
              adgrouptype[:exactNegativeWords]  =   param[:exact_negative]    if    param[:exact_negative] 
              adgrouptype[:pause]                            =   param[:pause]                    if    param[:pause] 
              adgrouptype[:status]                            =   param[:status]                    if    param[:status] 
              adgrouptype[:reserved]                       =   param[:reserved]               if    param[:reserved] 
              
              adgrouptypes << adgrouptype
            }
            return adgrouptypes
        end #make_adgrouptype

      end # class group
    end # class baidu
  end # API
end # module