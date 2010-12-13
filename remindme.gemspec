Gem::Specification.new do |s|
  s.name = 'remindme'
  s.version = '0.0.7'
  s.homepage = 'http://wiki.github.com/eric1234/remindme/'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rails', '> 3'
  s.files = Dir['**/*.rb'] + Dir['**/*.rake'] + Dir['**/*.erb']
  s.has_rdoc = true
  s.extra_rdoc_files << 'README'
  s.rdoc_options << '--main' << 'README'
  s.summary = 'Sits on top of authlogic to provide forgot password feature'
  s.description = <<-DESCRIPTION
    A UI plugin that sits on top of authlogic to provide a forgot
    password feature. Can be used in conjunction with related logmein
    plugin which provide basic access restriction and login support.
  DESCRIPTION
end
