require 'faker'

FactoryBot.define do
  factory :comment do
    comment_content { Faker::Lorem.sentence(word_count: 25) }
    commentable { create(:work).last_posted_chapter }
    pseud { create(:user).default_pseud }

    trait :by_guest do
      pseud { nil }
      name { Faker::Name.first_name }
      email { Faker::Internet.email }
    end

    trait :on_admin_post do
      commentable { create(:admin_post) }
    end

    trait :on_tag do
      commentable { create(:fandom) }
    end

    trait :unreviewed do
      commentable { create(:work, moderated_commenting_enabled: true).last_posted_chapter }
      unreviewed { true }
    end

    trait :on_non_chaptered_work do
      commentable { create(:work) }
    end

    trait :on_multi_chaptered_work do
      commentable { create(:work, :with_chapter_title).last_posted_chapter }
    end
  end

  factory :inbox_comment do
    user { create(:user) }
    feedback_comment { create(:comment) }
  end
end
