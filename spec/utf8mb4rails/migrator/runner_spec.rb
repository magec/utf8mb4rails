require 'spec_helper'
require_relative '../../../lib/utf8mb4rails/migrator'

describe Utf8mb4rails::Migrator::Runner, integration: true do
  let(:migration_path) { [MIGRATION_FIXTURES] }
  let(:direction) { :up }

  before do
    ActiveRecord::Migrator.run(:down, migration_path, 2)
    ActiveRecord::Migrator.run(:up, migration_path, 2)
  end

  let(:runner) do
    described_class.new
  end

  let(:inspector) { Utf8mb4rails::Migrator::DBInspector.new }

  describe '#migrate_column!' do
    context 'when the column is VARCHAR and in utf8' do
      let!(:charset_before) { inspector.column_info('migration_tests', 'name').info[:charset] }
      before { runner.migrate_column!('migration_tests', 'name') }

      subject { inspector.column_info('migration_tests', 'name') }
      it { expect(subject.utf8mb4?).to be_truthy }
      it { expect(subject.info[:charset]).not_to eq(charset_before) }
    end

    context 'when the column is VARCHAR and in utf8 and we fill up the field' do
      let!(:charset_before) { inspector.column_info('migration_tests', 'name').info[:charset] }
      before { runner.migrate_column!('migration_tests', 'name') }

      subject { inspector.column_info('migration_tests', 'name') }
      it { expect(subject.utf8mb4?).to be_truthy }
      it { expect(subject.info[:charset]).not_to eq(charset_before) }
    end
  end
end
