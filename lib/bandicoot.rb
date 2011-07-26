require "csv"
require "net/http"
require "uri"

# Client for connecting to the Bandicoot server.
class Bandicoot
  attr :http

  def initialize(url = "localhost", port = 12345)
    @http = Net::HTTP.new(url, port)
  end

  def get(what)
    reply(http.get("/#{what}"))
  end

  def post(where, what)
    reply(http.post("/#{where}", what))
  end

  def reply(res)
    raise RuntimeError, res.inspect unless res.code == "200"
    CSV.parse(res.body)
  end

  # Mapper for Bandicoot relations.
  class Rel
    @@fields = {}

    def self.field(name, type)
      @@fields[name] = type
      attr_accessor name
    end

    def self.from_csv(csv)
      from_array(CSV.parse(csv))
    end

    def self.from_array(list)
      return ArgumentError unless list.size == 2

      header = list[0]
      values = list[1]

      rel = new

      header.map do |field|
        field.split(":").first
      end.zip(values).each do |field, value|
        rel.send(:"#{field}=", transform(value, @@fields[field.to_sym]))
      end

      rel
    end

    def self.transform(value, type)
      case type
      when :int then value.to_i
      when :long then value.to_i
      when :real then value.to_f
      else value
      end
    end

    def initialize(attrs = {})
      attrs.each do |field, value|
        send(:"#{field}=", value)
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << header
        csv << values
      end
    end

    def values
      fields.map do |field, _|
        send(field)
      end
    end

    def header
      fields.map do |field, type|
        "#{field}:#{type}"
      end
    end

    def fields
      @@fields
    end
  end
end
