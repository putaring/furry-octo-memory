module UsersHelper
  def metric_height(height_in_inches)
    feet    = "#{height_in_inches / 12} ft"
    inches  = (height_in_inches % 12 == 0) ? "" : "#{height_in_inches % 12} in"
    "#{feet} #{inches}".strip
  end
end
