$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "bandicoot"

db = Bandicoot.new

prepare do
  db.get(:clear)
end

test do
  db.post(:push, [{"id:int" => 1, "pid:int" => 2, "ts:long" => 3}])
  assert_equal 1, db.get(:list).first["id:int"]
end
