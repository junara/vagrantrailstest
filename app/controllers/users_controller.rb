# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(100)
  end
end
