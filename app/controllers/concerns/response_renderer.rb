module ResponseRenderer
  extend ActiveSupport::Concern

    def render_success(message: nil, data: nil)
        success(success: true, message:, data:)
    end

    def render_error(message: "Something went wrong", data: nil, status_code: 400)
        render(json: { success: false, error: message, data: }, status: status_code)
    end

    def success(success: true, message: nil, data: nil, status_code: 200)
        render(json: { success:, message:, data: }, status: status_code)
    end
end
