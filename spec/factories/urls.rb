FactoryBot.define do
  factory :click do
    browser { ['IE', 'Firefox', 'Chrome', 'Safare'].sample }
    platform { ['Windows', 'Ubuntu', 'Mac'].sample }
    url
  end

  factory :url do
    short_url { Array.new(5) { Array(0..9).sample }.join }
    sequence(:original_url) {|n| "http://foo#{n}.com" }

    factory :url_with_clicks do

      transient do
        clicks_count { 10 }
      end

      after(:create) do | url, evaluator |
        create_list(:click, evaluator.clicks_count, url: url)

        url.reload
      end
    end
  end
end