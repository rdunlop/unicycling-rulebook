class BaseState
  attr_accessor :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  def is_open_for_comments?
    true
  end

  delegate :review_end_date, to: :proposal
  delegate :review_start_date, to: :proposal
  delegate :vote_end_date, to: :proposal
  delegate :vote_start_date, to: :proposal
  delegate :tabled_date, to: :proposal
end
