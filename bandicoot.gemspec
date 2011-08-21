require "./lib/bandicoot"

Gem::Specification.new do |s|
  s.name              = "bandicoot"
  s.version           = Bandicoot::VERSION
  s.summary           = "Bandicoot client."
  s.description       = "Client for the Bandicoot relational algebra database."
  s.authors           = ["Michel Martens"]
  s.email             = ["michel@soveran.com"]
  s.homepage          = "http://github.com/soveran/bandicoot"

  s.files = Dir[
    "LICENSE",
    "README*",
    "Rakefile",
    "lib/**/*.rb",
    "*.gemspec",
    "test/*.*",
    "data/sample.b"
  ]
end
