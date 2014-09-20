class ReviewState < BaseState
  def status_summary
    "Ends " + review_end_date.to_date.to_s(:long)
  end

  def status_string
    "Review from " + review_start_date.to_date.to_s(:long) + " to " + review_end_date.to_date.to_s(:long)
  end
end
