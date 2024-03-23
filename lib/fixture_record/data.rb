class FixtureRecord::Data < Hash

  def initialize(...)
    super(...)
    self.default_proc = Proc.new { |hash, klass| hash[klass] = load_fixture_for(klass) }
  end

  def load_fixture_for(klass)
    if File.exist?(fixture_path_for(klass))
      YAML.load_file(fixture_path_for(klass))
    else
      {}
    end
  end

  def write!
    self.each do |klass, data|
      File.open(fixture_path_for(klass), 'w') { |f| f.write data.to_yaml }
    end
  end

  def fixture_path_for(klass)
    Rails.root.join('test/fixtures', klass.table_name + '.yml')
  end

  def merge_record(record)
    key = record.test_fixture_name

    self[record.class].merge!(key => record._fixture_record_attributes) unless self[record.class].key?(key)
  end
end
