require "csv"
require "net/http"
require "uri"

class Bandicoot
  VERSION = "0.0.1"

  # Basic HTTP client that sends and receives CSV.
  class Client
    attr :http

    def initialize(host, port)
      @http = Net::HTTP.new(host, port)
    end

    def get(fn)
      reply(http.get("/#{fn}"))
    end

    def post(fn, csv)
      reply(http.post("/#{fn}", csv))
    end

    def reply(res)
      unless res.code == "200"
        raise RuntimeError, res.inspect
      end

      res.body
    end
  end

  attr :client

  def initialize(url = "http://localhost:12345")
    url = URI.parse(url)
    @client = Client.new(url.host, url.port)
  end

  def get(fn)
    _csv_to_hashes(client.get(fn))
  end

  def post(fn, hashes)
    _csv_to_hashes(client.post(fn, _hashes_to_csv(hashes.dup)))
  end

private

  def _csv_to_hashes(csv)
    rows = CSV.parse(csv)
    head = rows.shift

    rows.map do |row|
      _row_to_hash(row, head)
    end
  end

  def _hashes_to_csv(hashes)
    first = hashes.shift

    CSV.generate do |csv|
      csv << first.keys
      csv << first.values

      hashes.each do |hash|
        csv << hash.values
      end
    end
  end

  def _row_to_hash(row, head)
    record = []

    head.zip(row) do |field, value|
      record << field
      record << _cast(value, _type_of(field))
    end

    Hash[*record]
  end

  def _record_to_csv(record)
    CSV.generate do |csv|
      csv << record.keys
      csv << record.values
    end
  end

  def _type_of(field)
    field.split(":").last
  end

  def _cast(value, type)
    case type
    when "int" then value.to_i
    when "long" then value.to_i
    when "real" then value.to_f
    else value
    end
  end
end
