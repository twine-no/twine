# frozen_string_literal: true

fixture_files = Rails.root.glob('test/fixtures/**')

fixtures_batches = [
  %w[users]
]

all_fixtures = fixture_files.map(&:to_s).filter_map do |fixture_file_path|
  next unless fixture_file_path.include?('.yml')

  fixture_file_path.split('/').last.split('.').first
end

other_fixtures = all_fixtures
fixtures_batches.each { |fixtures| other_fixtures -= fixtures }
[ *fixtures_batches, other_fixtures ].each.with_index(1) do |fixtures_batch, index|
  ENV['FIXTURES'] = fixtures_batch.join(', ')
  Rails.logger.debug { "Loading fixtures batch #{index} - (#{ENV.fetch('FIXTURES', nil)})..." }
  Rake::Task['db:fixtures:load'].execute
end
