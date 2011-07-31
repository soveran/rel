# Mapper for Bandicoot relations.
class Bandicoot
  class Rel
    @@fields = Hash.new { |hash, key| hash[key] = {} }

    def self.field(name, type)
      @@fields[self.name][name] = type
      attr_accessor name
    end

    def initialize(attrs = {})
      attrs.each do |field, value|
        name, type = field.to_s.split(":")
        send(:"#{name}=", value)
      end
    end

    def to_hash
      record = []

      header.zip(values) do |field, value|
        record << field
        record << value
      end

      Hash[*record]
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
      @@fields[self.class.name]
    end
  end
end
