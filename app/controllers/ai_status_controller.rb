# frozen_string_literal: true

class AiStatusController < ApplicationController
  def show
    status = AiModelService.model_status

    render json: {
      ok: status[:gateway_status] == 'online',
      gateway: status[:gateway_status],
      models: status[:models],
      checked_at: status[:checked_at]
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("/ai/status error: #{e.message}")
    render json: { ok: false, error: e.message }, status: :service_unavailable
  end
end
