class DashboardController < ApplicationController
  before_action :initialize_new_users

  def index
    @current_user = current_user
    @account = Account.where(user_id: current_user.id).first || Account.new

    @projection = @account.calculate_projection(@current_user)

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "401k Balance By Year")
      f.xAxis(categories: @projection[:years])
      f.series(name: "Balance Without Inflation", yAxis: 0, data: @projection[:yearly_balance_summary])
      f.series(name: "Interest Gained", yAxis: 0, data: @projection[:yearly_interest_summary])
      f.series(name: "Inflation Loss", yAxis: 0, data: @projection[:yearly_inflation_summary])
      f.series(name: "Balance After Inflation", yAxis: 0, data: @projection[:balance_after_inflation])

      f.yAxis [
                  {title: {text: "Thousands of Dollars ($)", margin: 70} }
              ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
      f.colors(['#008000', '#ADFF2F', '#FF0000', '#4B0082'])
    end

  end

  private

  def initialize_new_users
    if current_user.accounts.empty?
      puts "test"
      redirect_to new_account_path
    end
  end
end
