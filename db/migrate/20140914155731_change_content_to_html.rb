class ChangeContentToHtml < ActiveRecord::Migration[4.2]
  include ActionView::Helpers::TextHelper

  def up
    Comment.all.each do |comment|
      convert_to_html(comment, :comment)
    end
    Revision.all.each do |revision|
      convert_to_html(revision, :background)
      convert_to_html(revision, :rule_text)
      convert_to_html(revision, :body)
      convert_to_html(revision, :references)
      convert_to_html(revision, :change_description)
    end
  end

  def down
    Comment.all.each do |comment|
      convert_from_html(comment, :comment)
    end
    Revision.all.each do |revision|
      convert_from_html(revision, :background)
      convert_from_html(revision, :rule_text)
      convert_from_html(revision, :body)
      convert_from_html(revision, :references)
      convert_from_html(revision, :change_description)
    end
  end

  private

  def convert_to_html(model, field)
    model.update_attribute(field, simple_format(model.send(field)))
  end

  def convert_from_html(model, field)
    model.update_attribute(field, strip_tags(model.send(field)))
  end
end
