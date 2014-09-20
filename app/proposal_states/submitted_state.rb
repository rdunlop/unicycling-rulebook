class SubmittedState < BaseState
  def status_summary
    ""
  end

  def status_string
    "Submitted"
  end

  can_transition_to "Review"

  def state_name
    "Submitted"
  end
end
