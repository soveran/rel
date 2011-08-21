$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "rel"
require "rel/model"

class Item < Rel::Model
  field :id, :int
  field :pid, :int
  field :ts, :long

  def save(db)
    db.post(:push, [to_hash])
  end
end

db = Rel.new

prepare do
  db.get(:clear)
end

test "extending relations" do
  item = Item.new(id: 1, pid: 0, ts: 1310084883)
  item.save(db)

  assert_equal item.to_hash, db.get(:list).first
end
