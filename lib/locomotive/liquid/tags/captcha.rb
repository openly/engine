module Locomotive
  module Liquid
    module Tags
      module Captcha

        class CCCaptcha < ::Liquid::Tag
          def render(context)
            Locomotive::Recaptcha::ClientHelper.recaptcha_tags
          end
        end

      end

      ::Liquid::Template.register_tag('cc_captcha', Captcha::CCCaptcha)

    end
  end
end