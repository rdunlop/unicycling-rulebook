class PreVotingState < BaseState
  def status_summary
    "Ended " + review_end_date.to_date.to_s(:long)
  end

  def status_string
    "Pre-Voting (Reviewed from " + review_start_date.to_date.to_s(:long) + " to " + review_end_date.to_date.to_s(:long) + ")"
  end

  can_transition_to "Tabled"

  def state_name
    "Pre-Voting"
  end
end
