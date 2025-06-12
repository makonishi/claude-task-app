FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    status { 'not_started' }
    priority { '2' }
    due_date { Date.current + 7.days }
    
    trait :not_started do
      status { 'not_started' }
    end
    
    trait :in_progress do
      status { 'in_progress' }
    end
    
    trait :completed do
      status { 'completed' }
    end
    
    trait :on_hold do
      status { 'on_hold' }
    end
    
    trait :high_priority do
      priority { '3' }
    end
    
    trait :critical_priority do
      priority { '4' }
    end
    
    trait :medium_priority do
      priority { '2' }
    end
    
    trait :low_priority do
      priority { '1' }
    end
    
    trait :overdue do
      due_date { Date.current - 1.day }
    end
    
    trait :due_soon do
      due_date { Date.current + 1.day }
    end
    
    trait :no_due_date do
      due_date { nil }
    end
  end
end