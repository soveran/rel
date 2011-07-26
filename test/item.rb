$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "bandicoot"

class Item < Bandicoot::Rel
  field :id, :int
  field :pid, :int
  field :ts, :long
end

head = [["id:int", "pid:int", "ts:long"]]

single_item_csv = CSV.generate do |csv|
  csv << head.first
  csv << [1, 0, 1310084883]
end

test "convert item to CSV" do
  item = Item.new
  item.id = 1
  item.pid = 0
  item.ts = 1310084883
  assert_equal item.to_csv, single_item_csv
end

test "mass assignment of attributes on creation" do
  item = Item.new(id: 1, pid: 0, ts: 1310084883)
  assert_equal item.to_csv, single_item_csv
end

test "item from csv" do
  item = Item.from_csv(single_item_csv)

  assert_equal item.to_csv, single_item_csv
end

test "item from array" do
  item = Item.from_array(CSV.parse(single_item_csv))

  assert_equal item.to_csv, single_item_csv
end
