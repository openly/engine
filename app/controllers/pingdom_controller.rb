require "rest_client"
require "json"
class PingdomController < ApplicationController
    def proxy
        host = PINGDOM_CONFIG['host'];
        headers = {"App-Key" => PINGDOM_CONFIG['App-key'],"Authorization"=>PINGDOM_CONFIG['Authorization']}
        path = PINGDOM_CONFIG['path'] or "";
        uri = host + URI.unescape(path);
        begin
        res = RestClient.get(uri,headers);
        rescue => e
            res = e.to_s;
        end
        getStatus(res)

    end

    def getStatus(res)
        statusArr = {};
        sites = PINGDOM_CONFIG['sites'];
        checks = JSON.parse(res.body)['checks'];
        checks.each do |check| 
            if sites.include? check['name']
                statusArr[check['name']] = check['status']
            end
        end
        print "#{statusArr}"
        render inline: statusArr.to_json
    end

end