$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "bandicoot"

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
  assert_equal head, db.get(:list)
end

test "push items to the queue" do
  assert_equal [], db.post(:push, list_csv)
  assert_equal list, db.get(:list)
end
