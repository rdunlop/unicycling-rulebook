class PreVotingState < BaseState
  def status_summary
    "Ended " + review_end_date.to_date.to_fs(:long)
  end

  def status_string
    "Pre-Voting (Reviewed from " + review_start_date.to_date.to_fs(:long) + " to " + review_end_date.to_date.to_fs(:long) + ")"
  end

  can_transition_to "Tabled"
  can_transition_to "Voting"

  def state_name
    "Pre-Voting"
  end
end
