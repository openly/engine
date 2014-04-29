require "rest_client"
class ApiController < ApplicationController
  def proxy
    hosts = {}
    hosts["cc"]= "http://api.uat1.ccycloud.com"


    host = hosts[params[:host]];
    path = params[:path] or "";
    if(params[:query] != nil)
      query = URI.encode_www_form(params[:query])\
    end

    uri = host + path

    if(query != nil)
      uri = uri + "?#{query}" 
    end

    print "Proxying for URL: #{uri}\n";
    print "Post Parameters: #{params[:post]}\n\n"

    postParams = params[:post]

    begin
      case params[:method]
        when "get"
          res = RestClient.get(uri);
          break;
        when "post"
          res = RestClient.post(uri, params[:post]);
          break;
        when "delete"
          res = RestClient.delete(uri);
          break;
        when "put"           
          res = RestClient.get(uri, params[:post]);
          break;
      end
    rescue => e
      res = e.response
    end
    print "Response: #{res}"
    render inline: res
  end
end