require 'spec_helper'

describe InboxHelper do

  describe "commentable_description_link" do
    context "for Deleted Objects" do
      it "should return the String 'Deleted Object'" do
        @commentable = FactoryBot.build(:comment, commentable_id: nil, commentable_type: nil)
        expect(commentable_description_link(@commentable)).to eq "Deleted Object"
      end
    end

    context "for Tags" do
      it "should return a link to the Comment on the Tag" do
        @commentable = FactoryBot.create(:comment, :on_tag)
        string = commentable_description_link(@commentable)
        expect(string.gsub("%20", " ")).to eq "<a href=\"/tags/#{@commentable.ultimate_parent.name}/comments/#{@commentable.id}\">#{@commentable.ultimate_parent.name}</a>"
      end
    end

    context "for AdminPosts" do
      it "should return a link to the Comment on the Adminpost" do
        @commentable = FactoryBot.create(:comment, :on_admin_post)
        expect(commentable_description_link(@commentable)).to eq "<a href=\"/admin_posts/#{@commentable.ultimate_parent.id}/comments/#{@commentable.id}\">#{@commentable.ultimate_parent.title}</a>"
      end
    end

    context "for Works" do
      context "with chapters" do
        it "returns two links to the Comment on the Work and the Chapter" do
          @commentable = FactoryBot.create(:comment, :on_multi_chaptered_work)
          chapter = @commentable.original_ultimate_parent

          work_link = "<a href=\"/works/#{@commentable.ultimate_parent.id}/comments/#{@commentable.id}\">#{@commentable.ultimate_parent.title}</a>"
          chapter_link = "<a href=\"/works/#{@commentable.ultimate_parent.id}/chapters/#{chapter.id}\">#{chapter.title}</a>"

          expect(commentable_description_link(@commentable)).to eq chapter_link + " #{ts('of')} " + work_link
        end

        context("chapter title is blank") do
          it "returns a link to the Comment on the Work" do
            @commentable = FactoryBot.create(:comment)
            expect(commentable_description_link(@commentable)).to eq "<a href=\"/works/#{@commentable.ultimate_parent.id}/comments/#{@commentable.id}\">#{@commentable.ultimate_parent.title}</a>"
          end
        end
      end

      context "without chapters" do
        it "should return a link to the Comment on the Work with chapters" do
          @commentable = FactoryBot.create(:comment, :on_non_chaptered_work)
          expect(commentable_description_link(@commentable)).to eq "<a href=\"/works/#{@commentable.ultimate_parent.id}/comments/#{@commentable.id}\">#{@commentable.ultimate_parent.title}</a>"
        end
      end
    end
  end
end
