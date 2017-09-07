require 'spec_helper'
require_relative '../../../lib/utf8mb4rails/migrator'

describe Utf8mb4rails::Migrator::DBInspector, integration: true do

  let(:inspector) do
    described_class.new
  end

  let(:migration_path) { [MIGRATION_FIXTURES] }
  let(:direction) { :up }

  before { ActiveRecord::Migrator.run(direction, migration_path, 1) }

  describe '#columns' do
    subject { inspector.columns('activities') }
    it { is_expected.not_to be_empty }
    it { is_expected.to eq %w(id name description created_at updated_at) }
  end

  describe '#column_info' do
    subject { inspector.column_info('activities', 'description') }
    it { is_expected.to be_instance_of(Utf8mb4rails::Migrator::ColumnInfo) }
    it { expect(subject.info[:type]).to eq('TEXT') }
    it { expect(subject.text_column?).to be_truthy }
  end
end
