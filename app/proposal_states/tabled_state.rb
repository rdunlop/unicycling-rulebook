class TabledState < BaseState
  def is_open_for_comments?
    false
  end

  def status_summary
    "" + tabled_date.to_date.to_s(:long)
  end

  def status_string
    "Set-Aside (Reviewed from " + review_start_date.to_date.to_s(:long) + " to " + review_end_date.to_date.to_s(:long) + ")"
  end

  def on_enter
    proposal.status = "Tabled"
    proposal.tabled_date = Date.today()
  end

  def state_name
    "Tabled"
  end
end
