require 'spec_helper'
require_relative '../../lib/utf8mb4rails/migrator'

describe Utf8mb4rails::Migrator::Runner, integration: true do
  let(:migration_path) { [MIGRATION_FIXTURES] }
  class MigrationTest < ActiveRecord::Base; end

  before do
    ActiveRecord::Migrator.run(:down, migration_path, 2)
    ActiveRecord::Migrator.run(:up, migration_path, 2)
  end

  let(:inspector) { Utf8mb4rails::Migrator::DBInspector.new }
  let(:runner) { Utf8mb4rails::Migrator::Runner.new }

  describe 'An Active Record Model' do
    let!(:max_char_test) { MigrationTest.create(name: 'b' * 255) }

    subject { MigrationTest.new }

    context 'a column is in utf8' do
      context 'and we set it to something not in utf8' do
        before { subject.name = '🏡' }
        it { expect { subject.save }.to raise_error ActiveRecord::StatementInvalid }
      end

      context 'and we fill it up with more than its max size' do
        before { subject.name = 'a' * 256 }
        it { expect { subject.save }.to raise_error ActiveRecord::StatementInvalid }
      end

      context 'and we migrate it to utf8mb4' do
        before do
          runner.migrate_column!('migration_tests', 'name')
        end

        it { expect(max_char_test.reload.name.size).to eq(255) }
        it { expect(inspector.column_info('migration_tests', 'name').utf8mb4?).to be_truthy }
      end
    end
  end
end
