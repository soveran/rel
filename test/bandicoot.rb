$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "bandicoot"
require "pp"

db = Bandicoot.new

head = [["id:int", "pid:int", "ts:long"]]

list_csv = CSV.generate do |csv|
  csv << head.first
  csv << [1, 0, 1310084883]
  csv << [2, 0, 1310084888]
end

list = CSV.parse(list_csv)

prepare do
  db.get(:clear)
end

test "get" do
  assert_equal head, CSV.parse(db.client.get(:list))
end

test "push items to the queue" do
  assert_equal "", db.client.post(:push, list_csv)
  assert_equal list_csv, db.client.get(:list)
end

test "primitive types in parameters" do
  db.post("push", [{"id:int" => 1,
                    "pid:int" => 1,
                    "ts:long" => 100}])
  db.post("push", [{"id:int" => 2,
                    "pid:int" => 2,
                    "ts:long" => 200}])

  assert_equal 2, db.get("recent?t=150").first["id:int"]
end
