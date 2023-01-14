module ApplicationHelper
  def pick_random_number_based_on_month
    month = Date.current.month

    if month == 2
      8
    elsif month == 2
      5
    elsif month == 3
      4
    elsif month == 4
      5
    elsif month == 5
      3
    elsif month == 6
      5
    elsif month == 7
      4
    elsif month == 8
      5
    elsif month == 9
      3
    elsif month == 10
      4
    elsif month == 11
      5
    elsif month == 12
      4
    end
  end
end
