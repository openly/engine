module Locomotive
  module Public
    class ContentEntriesController < Public::BaseController

      include Locomotive::Render

      before_filter :set_locale

      before_filter :set_content_type

      before_filter :sanitize_entry_params, only: :create

      respond_to :html, :json

      def create
        if (params.has_key?(:recaptcha_challenge_field))
          if(params[:recaptcha_response_field].empty?)
            captchaRes = {'status' => false, 'error' => 'Captcha Field cannot be blank'}
          else
            captchaRes = Locomotive::Recaptcha::Verify.verify_recaptcha(request, params)
          end
        else 
          captchaRes = {'status' => true}
        end

        if (captchaRes['status'] == true) 
          @entry = @content_type.entries.safe_create(params[:entry] || params[:content])
        else 
          params[:content][:subject] = ""
          @entry = @content_type.entries.safe_create(params[:entry] || params[:content])
          @entry.errors.clear
          @entry.errors[:captcha] << captchaRes['error']
        end

        respond_with @entry, {
          location:   self.callback_url,
          responder:  Locomotive::ActionController::PublicResponder
        }

      end

      protected

      def set_locale
        ::I18n.locale = params[:locale] || current_site.default_locale
        ::Mongoid::Fields::I18n.locale = ::I18n.locale
      end

      def set_content_type
        @content_type = current_site.content_types.where(slug: params[:slug]).first

        # check if ability to receive public submissions
        unless @content_type.public_submission_enabled?
          respond_to do |format|
            format.json { render json: { error: 'Public submissions not accepted' }, status: :forbidden }
            format.html { render text: 'Public submissions not accepted', status: :forbidden }
          end
          return false
        end
      end

      def callback_url
        (@entry.errors.empty? ? params[:success_callback] : params[:error_callback]) || main_app.root_path
      end

      def sanitize_entry_params
        entry_params = params[:entry] || params[:content] || {}
        entry_params.each do |key, value|
          next unless value.is_a?(String)
          entry_params[key] = Sanitize.clean(value, Sanitize::Config::BASIC)
        end
      end

      def handle_unverified_request
        if Locomotive.config.csrf_protection
          reset_session
          redirect_to '/', status: 302
        end
      end

    end
  end
end