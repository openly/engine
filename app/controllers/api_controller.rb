require "rest_client"
class ApiController < ApplicationController
  def proxy
    hosts = {}
    hosts["cc"]= "http://localhost"


    host = hosts[params[:host]];
    path = params[:path] or "";
    if(params[:query] != nil)
      query = URI.encode_www_form(params[:query])\
    end

    uri = host + path

    if(query != nil)
      uri = uri + "?#{query}" 
    end

    
    print "Post Parameters: #{params[:post]}\n\n"
    
    postParams = params[:post]

    begin
      case params[:method]
        when "get"
          res = RestClient.get(uri,params[:headers]);
        when "post"
          res = RestClient.post(uri, params[:post],params[:headers]);
        when "delete"
          res = RestClient.delete(uri);
        when "put"           
          res = RestClient.get(uri, params[:post]);
      end
    rescue => e
      res = e.response
    end
    print "Response: #{res}"
    render inline: res
  end
end
