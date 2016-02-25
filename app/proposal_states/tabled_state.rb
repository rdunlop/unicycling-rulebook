class TabledState < BaseState
  def is_open_for_comments?
    true
  end

  def status_summary
    "" + tabled_date.to_date.to_s(:long)
  end

  def status_string
    "Set-Aside (Reviewed from " + review_start_date.to_date.to_s(:long) + " to " + review_end_date.to_date.to_s(:long) + ")"
  end

  can_transition_to "Review"

  def on_enter
    proposal.tabled_date = Date.current
  end

  def state_name
    "Tabled"
  end
end
