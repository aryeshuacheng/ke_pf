class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def edit
    @account = Account.where(user_id: current_user.id).first
  end

  def update
    @account = Account.where(user_id: current_user.id).first
    @account.update(account_params)

    redirect_to dashboard_index_url
  end
  def create
    account = Account.create(initial_balance: params[:initial_balance],
                             annual_roi_percentage: params[:annual_roi_percentage],
                             annual_contribution: params[:annual_contribution])
    account.update(user_id: current_user.id)

    redirect_to dashboard_index_url
  end

  private

  def account_params
    params.permit(:initial_balance, :annual_roi_percentage, :annual_contribution)
  end
end
