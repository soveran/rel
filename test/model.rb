$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "rel"
require "rel/model"

class Item < Rel::Model
  field :id, :int
  field :pid, :int
  field :ts, :long
end

class Other < Rel::Model
  field :conflict, :string
end

item_hash = { "id:int" => 1, "pid:int" => 0, "ts:long" => 1310084883 }

test "convert item to hash" do
  item = Item.new
  item.id = 1
  item.pid = 0
  item.ts = 1310084883
  assert_equal item.to_hash, item_hash
end

test "create item from hash" do
  item = Item.new(item_hash)
  assert_equal item.to_hash, item_hash
end

test "mass assignment of attributes on creation" do
  item = Item.new(id: 1, pid: 0, ts: 1310084883)
  assert_equal item.to_hash, item_hash
end

test "shouldn't have conflicts with other classes" do
  item = Item.new(id: 1, pid: 0, ts: 1310084883)
  other = Other.new(conflict: "None")
end
