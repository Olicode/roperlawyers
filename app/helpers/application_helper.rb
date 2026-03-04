module ApplicationHelper
  def pick_random_number_based_on_month
    month_map = {
      1 => 3, 2 => 5, 3 => 4, 4 => 5, 5 => 3, 6 => 5,
      7 => 4, 8 => 5, 9 => 3, 10 => 4, 11 => 5, 12 => 2
    }
    month_map[Date.current.month]
  end
end
