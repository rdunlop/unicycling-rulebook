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

  can_transition_to "Pre-Voting"

  def on_enter
    proposal.vote_start_date = Date.current
    proposal.vote_end_date = @proposal.vote_start_date.next_day(7)
  end

  def state_name
    "Voting"
  end
end
