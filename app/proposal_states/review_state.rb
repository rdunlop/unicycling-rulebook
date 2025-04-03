class ReviewState < BaseState
  def status_summary
    "Ends " + review_end_date.to_date.to_fs(:long)
  end

  def status_string
    "Review from " + review_start_date.to_date.to_fs(:long) + " to " + review_end_date.to_date.to_fs(:long)
  end

  can_transition_to "Tabled"

  def on_enter
    proposal.review_start_date = Date.current
    proposal.review_end_date = proposal.review_start_date.next_day(Rulebook.current_rulebook.review_days)
  end

  def state_name
    "Review"
  end
end
