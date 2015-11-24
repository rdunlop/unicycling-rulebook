class CommentPolicy < ApplicationPolicy
  def create?
    (user.admin || user.is_in_committee(record.discussion.committee)) && record.discussion.is_open_for_comments?
  end
end
