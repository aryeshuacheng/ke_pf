class Account < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user

  AVERAGE_INFLATION_RATE = (2.25/100)


  def calculate_projection(user)
    years_remaining = user.retirement_age - (Date.current.year - user.birth_year)
    years_of_inflation = 1
    years_summary = []
    yearly_balance_summary = []
    yearly_inflation_summary = []
    yearly_interest_summary = []
    balance_after_inflation = []
    annual_roi_percent = self.annual_roi_percentage/100

    while years_remaining > 0
      year = Date.current.year.to_i + years_of_inflation - 1

      if years_of_inflation == 1
        balance_with_interest = (self.initial_balance * ( 1 + (annual_roi_percent/12))**(12)) + self.annual_contribution
      else
        balance_with_interest = (yearly_balance_summary.last * ( 1 + (annual_roi_percent/12))**(12)) + self.annual_contribution
      end

      balance_without_interest = (self.initial_balance+(years_of_inflation*self.annual_contribution))
      interest_amount = balance_with_interest - balance_without_interest

      if years_of_inflation > 0
        inflation_amount = balance_with_interest * ( 1 - (AVERAGE_INFLATION_RATE))**(years_of_inflation+1) # Make take off +1
      elsif years_of_inflation == 0
        inflation_amount = self.initial_balance
      end

      # Add values to arrays
      years_summary.push(year)
      balance_after_inflation.push(inflation_amount.round(2))
      yearly_inflation_summary.push((balance_with_interest-balance_after_inflation.last).round(2))

      yearly_balance_summary.push(balance_with_interest.round(2))
      yearly_interest_summary.push(interest_amount.round(2))

      years_remaining = years_remaining - 1
      years_of_inflation += 1
    end

    summary = {years: years_summary, yearly_balance_summary: yearly_balance_summary, yearly_interest_summary: yearly_interest_summary, yearly_inflation_summary: yearly_inflation_summary, balance_after_inflation: balance_after_inflation}

    summary
  end

  def calculate_inflation(years)
    balances_by_year = calculate_projection(years)

    # Returns how much value you lost per year to inflation
    balances_by_year.map{|balance| (balance * (AVERAGE_INFLATION_RATE/100))}

    # Returns how much value you have
    balances_after_inflation = balances_by_year.map{|balance| (balance - (balance * AVERAGE_INFLATION_RATE/100))}

    balances_after_inflation
  end
end
