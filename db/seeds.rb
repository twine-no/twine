# frozen_string_literal: true

# Load test fixtures into the current environment database for seeding.
# Avoid using the Rake task so we can control load order and paths reliably.

fixtures_path = Rails.root.join('test', 'fixtures')

# Load critical dependencies first (e.g., users), then everything else.
fixtures_batches = [
  %w[users]
]

all_fixture_names = Dir.children(fixtures_path)
  .select { |f| f.end_with?('.yml') }
  .map { |f| File.basename(f, '.yml') }

other_fixtures = all_fixture_names - fixtures_batches.flatten

([ *fixtures_batches, other_fixtures ]).each.with_index(1) do |fixtures_batch, index|
  next if fixtures_batch.empty?

  ActiveRecord::FixtureSet.create_fixtures(fixtures_path.to_s, fixtures_batch)
end
