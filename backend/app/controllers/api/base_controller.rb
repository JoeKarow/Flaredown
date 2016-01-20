class Api::BaseController < ApplicationController
  include ExceptionLogger

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: ['Resource Not Found'] }, status: 404
  end

  rescue_from ActionController::UnknownFormat do
    render json: { errors: ['Format not supported'] }, status: 406
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    log_exception(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: "Required parameter missing: #{exception.param}" }, status: :unprocessable_entity
  end

  rescue_from ActionController::BadRequest do |exception|
    render json: { errors: ["Bad request: #{exception.message}"] }, status: :bad_request
  end

  rescue_from UnauthorizedException do |exception|
    log_exception(exception)
    render json: { errors: ['Unauthorized'] }, status: :unauthorized
  end

  protected

  def fetch_numeric_id_param
    id = params.require(:id)
    match_data = /^[[:digit:]]*$/.match(id)
    fail ActionController::BadRequest.new("id param must be a number") if match_data.nil?
    match_data[0].to_i
  end

end
