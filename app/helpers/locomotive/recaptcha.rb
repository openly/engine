module Locomotive
  module Recaptcha
    RECAPTCHA_API_SERVER_URL        = '//www.google.com/recaptcha/api'
    RECAPTCHA_API_SECURE_SERVER_URL = 'https://www.google.com/recaptcha/api'
    RECAPTCHA_VERIFY_URL            = 'http://www.google.com/recaptcha/api/verify'

    module ClientHelper

      def self.recaptcha_tags()

        key   = Recaptcha_PUBLIC_KEY
        raise RecaptchaError, "No public key specified." unless key

        uri   = RECAPTCHA_API_SERVER_URL

        html = %{<script type="text/javascript" src="#{uri}/challenge?k=#{key}"></script>\n}

        return (html.respond_to?(:html_safe) && html.html_safe) || html
      end # recaptcha_tags
    end # ClientHelper

    module Verify
      require "uri"

      def self.verify_recaptcha(request, params)

        if (defined? Recaptcha_SKIP_VERIFY_ENV)
          env = Rails.env.to_sym
          return {'status' => true} if Recaptcha_SKIP_VERIFY_ENV.include?("#{env}")
        end

        private_key = Recaptcha_PRIVATE_KEY
        raise RecaptchaError, "No private key specified." unless private_key

        begin
          recaptcha = nil
          if(defined? Recapthca_PROXY)
            proxy_server = URI.parse(Recapthca_PROXY)
            http = Net::HTTP::Proxy(proxy_server.host, proxy_server.port, proxy_server.user, proxy_server.password)
          else
            http = Net::HTTP
          end

          Timeout::timeout(3) do
            recaptcha = http.post_form(URI.parse(RECAPTCHA_VERIFY_URL), {
              "privatekey" => Recaptcha_PRIVATE_KEY,
              "remoteip"   => request.remote_ip,
              "challenge"  => params[:recaptcha_challenge_field],
              "response"   => params[:recaptcha_response_field]
            })
          end

          answer, error = recaptcha.body.split.map { |s| s.chomp }
          unless answer == 'true'
            message = "Word verification response is incorrect, please try again."
            return {'status' => false, 'error' => message}
          else
            return {'status' => true}
          end

        rescue Timeout::Error
          message = "Oops, we failed to validate your word verification response. Please try again."
          return {'status' => false, 'error' => message}

        rescue Exception => e
          raise Locomotive::Recaptcha::RecaptchaError, e.message, e.backtrace

        end

      end # verify_recaptcha
    end # Verify

    class RecaptchaError < StandardError
    end
  end # Recaptcha
end