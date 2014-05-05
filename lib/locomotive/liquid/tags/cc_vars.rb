module Locomotive
  module Liquid
    module Tags
      module CCVars

        class CCCDNTag < ::Liquid::Tag

          def render(context)
            ::CC_CDN
          end

        end

        class CCAPIPHostTag < ::Liquid::Tag

          def render(context)
            ::API_PROXY_HOSTS['cc']
          end

        end

      end

      ::Liquid::Template.register_tag('cc_cdn', CCVars::CCCDNTag)
      ::Liquid::Template.register_tag('cc_api_host', CCVars::CCAPIPHostTag)

    end
  end
end