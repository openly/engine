module Locomotive
  module Liquid
    module Tags
      module CCVars

        class CCCDNTag < ::Liquid::Tag

          def render(context)
            ::CC_CDN
          end

        end

      end

      ::Liquid::Template.register_tag('cc_cdn', CCVars::CCCDNTag)

    end
  end
end