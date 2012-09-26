Gem::Specification.new do |s|
  s.name = 'remindme'
  s.version = '0.2.1'
  s.homepage = 'https://github.com/eric1234/remindme'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rails', '> 3'
  s.add_dependency 'authlogic'
  s.add_development_dependency 'test_engine'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.files = Dir['**/*.rb'] + Dir['**/*.erb']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Sits on top of authlogic to provide forgot password feature'
  s.description = <<-DESCRIPTION
    A UI plugin that sits on top of authlogic to provide a forgot
    password feature. Can be used in conjunction with related logmein
    plugin which provide basic access restriction and login support.
  DESCRIPTION
end
