class FixtureRecord::Data < Hash

  def initialize(...)
    super(...)
    self.default_proc = Proc.new { |hash, klass| hash[klass] = load_fixture_for(klass) }
  end

  def load_fixture_for(klass)
    if File.exist?(fixture_path_for(klass))
      YAML.load_file(fixture_path_for(klass))
    else
      {'_fixture' => {'model_class' => klass.name}}
    end
  end

  def write!
    FileUtils.mkdir_p(FixtureRecord.base_path)
    self.each do |klass, data|
      File.open(fixture_path_for(klass), 'w') do |f|
        f.write data.to_yaml
      end
    end
  end

  def fixture_path_for(klass)
    if FixtureRecord.base_path.is_a?(String)
      [FixtureRecord.base_path, klass.table_name + '.yml'].join('/')
    else
      FixtureRecord.base_path.join(klass.table_name + '.yml')
    end
  end

  def merge_record(record)
    key = record.test_fixture_name

    self[record.class].merge!(key => record._fixture_record_attributes) unless self[record.class].key?(key)
  end
end
