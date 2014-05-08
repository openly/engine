require "rest_client"
class ApiController < ApplicationController
  def proxy
    host = API_PROXY_HOSTS[params[:host]];
    path = params[:path] or "";
    
    if(params[:query] != nil and params[:query] != "")
      query = URI.encode_www_form(params[:query])
    end

    uri = host + URI.unescape(path)

    if(query != nil)
      uri = uri + "?#{query}" 
    end

    print "Proxying for URL: #{uri}\n";
    print "Post Parameters: #{params[:post]}\n"

    postParams = params[:post]

    headers = {}

    if(params[:headers] != nil)
      headers = params[:headers]
    end

    begin
      case params[:method]
        when "get"
          res = RestClient.get(uri, headers);
        when "post"
          res = RestClient.post(uri, params[:post], headers);
        when "delete"
          res = RestClient.delete(uri, headers);
        when "put"           
          res = RestClient.get(uri, params[:post], headers);
      end
    rescue => e
      res = e.response
    end
    print "Response: #{res}\n\n"
    render inline: res
  end
end