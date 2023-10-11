module InboxHelper
  # Describes commentable - used on inbox show page
  def commentable_description_link(comment)
    commentable = comment.ultimate_parent

    return ts("Deleted Object") if commentable.blank?

    case commentable
    when Tag
      link_to commentable.name, tag_comment_path(commentable, comment)
    when AdminPost
      link_to commentable.title, admin_post_comment_path(commentable, comment)
    else
      work_title_link = link_to commentable.title, work_comment_path(commentable, comment)
      chapter = comment.original_ultimate_parent

      if chapter.is_a?(Chapter) && chapter.title.present?
        chapter_title_link = link_to(chapter.title, work_chapter_path(commentable, chapter)) + " #{ts('of')} "
        chapter_title_link + work_title_link
      else
        work_title_link
      end
    end
  end

  # get_commenter_pseud_or_name can be found in comments_helper

end
