class BaseState
  attr_accessor :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  def is_open_for_comments?
    true
  end

  def on_enter
    nil
  end

  def transition_to(new_state_name)
    if new_state_name.in? self.class.defined_transitions
      new_state = self.class.get_state(new_state_name).new(proposal)
      new_state.on_enter
      proposal.status = new_state.state_name
      proposal.save
    else
      false
    end
  end

  def self.get_state(name)
    "#{name.underscore.classify}State".constantize
  end

  def self.can_transition_to(new_state_name)
    @can_transition_to ||= []
    @can_transition_to << new_state_name
  end

  def self.defined_transitions
    @can_transition_to || []
  end

  delegate :review_end_date, to: :proposal
  delegate :review_start_date, to: :proposal
  delegate :vote_end_date, to: :proposal
  delegate :vote_start_date, to: :proposal
  delegate :tabled_date, to: :proposal
end
