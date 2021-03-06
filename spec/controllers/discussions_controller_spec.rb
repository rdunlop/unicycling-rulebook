# == Schema Information
#
# Table name: discussions
#
#  id           :integer          not null, primary key
#  proposal_id  :integer
#  title        :string
#  status       :string
#  owner_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  committee_id :integer
#  body         :text
#

require 'spec_helper'

describe DiscussionsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Revision. As you add validations to Revision, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { body: "blah",
      title: 'Something' }
  end

  let(:committee) { FactoryBot.create(:committee) }

  context "when not signed in" do
    describe "GET show" do
      it "assigns the requested revision as @revision" do
        discussion = FactoryBot.create(:discussion)

        get :show, params: { id: discussion.to_param }

        expect(assigns(:discussion)).to eq(discussion)
      end
    end
  end

  context "When signed in" do
    before(:each) do
      @admin = FactoryBot.create(:admin_user)
      sign_in @admin
    end

    describe "GET show" do
      it "assigns the requested revision as @revision" do
        discussion = FactoryBot.create(:discussion)

        get :show, params: { id: discussion.to_param }

        expect(assigns(:discussion)).to eq(discussion)
      end
      it "should have a blank comment object" do
        discussion = FactoryBot.create(:discussion)

        get :show, params: {id: discussion.to_param}

        expect(assigns(:comment)).to be_a_new(Comment)
      end
    end

    describe "GET new" do
      it "assigns a new discussion as @discussion" do
        get :new, params: { committee_id: committee.id }
        expect(assigns(:discussion)).to be_a_new(Discussion)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        describe "as a committee member" do
          before do
            FactoryBot.create(:committee_member, committee: committee, user: @admin)
          end
          it "creates a new Discussion" do
            expect {
              post :create, params: { discussion: valid_attributes, committee_id: committee.id}
            }.to change(Discussion, :count).by(1)
          end
        end
        describe "as a non-comimttee member" do
          it "does not create a new Discussion" do
            expect {
              post :create, params: { discussion: valid_attributes, committee_id: committee.id}
            }.to change(Discussion, :count).by(0)
          end
        end
      end
    end
  end
end
