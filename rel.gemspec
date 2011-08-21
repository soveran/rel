require "./lib/rel"

Gem::Specification.new do |s|
  s.name              = "rel"
  s.version           = Rel::VERSION
  s.summary           = "Bandicoot client."
  s.description       = "Client for the Bandicoot relational algebra database."
  s.authors           = ["Michel Martens"]
  s.email             = ["michel@soveran.com"]
  s.homepage          = "http://github.com/soveran/rel"

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
