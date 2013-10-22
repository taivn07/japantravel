# coding: utf-8

class ApplicationController < ActionController::Base
  attr_accessor :current_user
  respond_to :json

  class << self
    #
    # このメソッドを呼ぶと各アクションより前にaccess tokenのチェックが入る。
    # チェックが通るとController.current_userに当該ユーザー情報がセットされ、
    # リクエスト先アクションの処理が継続する。
    # チェックが通らない場合、Controller.current_userには何もセットされず(=nil)、
    # status: fail, message: 'Authentication required'がレスポンスされる。
    #
    # 前アクションが対象だが、引数options[:except]に配列でメソッド名が渡された場合、
    # そのメソッドはチェック対象外になる。
    #
    # ex) require_authenticate except: [:index, :show]
    #
    def require_authenticate(options=nil)
      @@authenticate_options ||= {}
      @@authenticate_options[self.name] = options
      before_filter :authenticate
    end
  end

  def set_offset
    params[:offset] ? params[:offset].to_i : 1
  end

  def set_limit
    params[:limit]  ? params[:limit].to_i  : 25
  end

  def respond_to_client(data = nil, errors = nil)
    begin
      if errors.nil?
        render_jsend(:success => data)
      else
        render_jsend(:fail => errors)
      end
    rescue => e
      render_jsend(:error => e.message)
    end
  end

  def authenticate
    options = @@authenticate_options[self.class.name]
    return if options.try(:[], :except).present? && options[:except].include?(action_name.to_sym)
    return head :bad_request unless params.has_key? :access_token

    if user = User.find_by_access_token(params[:access_token])
      self.current_user = user
    else
      respond_to_client nil, access_token: 'Authentication required.'
      return false
    end
  end

  def exception_handler e
    render_error e
  end

  def render_error e
    @response = APIResponse.new :error
    @response.message = e.message

    Rails.logger.error e.backtrace[0..9].join "\n"
    render template: 'templates/error', status: 500
  end

  def render_fail resource = nil
    @response = APIResponse.new 'fail', resource
    render template: 'templates/fail'
  end

  def render_success
    @response = APIResponse.new 'success', nil
    render template: 'templates/success'
  end

  #response template
  def render_template resource, render_option = nil, status = :success
    @response = APIResponse.new status, resource
    render render_option
  end
end
