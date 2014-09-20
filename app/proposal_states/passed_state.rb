class PassedState < BaseState
  def is_open_for_comments?
    false
  end

  def status_summary
    "" + vote_end_date.to_date.to_s(:long)
  end

  def status_string
    "Passed on " + vote_end_date.to_date.to_s(:long)
  end
end
