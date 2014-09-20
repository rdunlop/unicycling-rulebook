class VotingState < BaseState
  def is_open_for_comments?
    false
  end

  def status_summary
    "Ends " + vote_end_date.to_date.to_s(:long)
  end

  def status_string
    "Voting from " + vote_start_date.to_date.to_s(:long) + " to " + vote_end_date.to_date.to_s(:long)
  end

  def state_name
    "Voting"
  end
end
