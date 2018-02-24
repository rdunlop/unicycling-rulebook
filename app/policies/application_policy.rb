class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record

    # raise Pundit::NotAuthorizedError, "must be logged in" unless @user
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def admin?
    user&.admin?
  end

  def committee_admin?(committee = nil)
    user&.is_committee_admin(committee)
  end

  def committee_editor?(committee = nil)
    user&.is_committee_editor(committee)
  end

  def in_committee?(committee)
    user&.is_in_committee(committee)
  end

  def voting_member?(committee)
    user&.voting_member(committee)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
