Sham.name         { Faker::Name.name      }
Sham.email        { Faker::Internet.email }
Sham.identity_url { Faker::Internet.domain_name }

Application::App::User.blueprint do
  first_name          { Sham.name         }
  last_name           { Sham.name         }
  email               { Sham.email        }
  google_identity_url { Sham.identity_url }
end
