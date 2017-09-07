require 'spec_helper'
require_relative '../../../lib/utf8mb4rails/migrator'

describe Utf8mb4rails::Migrator::ColumnInfo, skip_db: true do

  let(:charset)    { 'utf8' }
  let(:type)       { 'VARCHAR' }
  let(:default)    { nil }
  let(:max_length) { 255 }

  let(:column_info) do
    described_class.new(type: type, default: default, max_length: max_length, charset: charset)
  end

  describe '#utf8bm4?' do
    subject { column_info.utf8mb4? }
    context 'when charset is utf8' do
      it { is_expected.to be_falsey }
    end

    context 'when charset is utf8mb4' do
      let(:charset) { 'utf8mb4' }
      it { is_expected.to be_truthy }
    end

    context 'when charset is nil' do
      let(:charset) { nil }
      it { is_expected.to be_falsey }
    end
  end

  describe '#new_type_for_sql' do
    subject { column_info.new_type_for_sql }

    context 'when type is no max length variable' do
      let(:type) { 'TEXT' }
      it { is_expected.to be(type) }
    end

    context 'when type is a max length variable' do
      it { is_expected.to eq('VARCHAR(255)') }
    end
  end

  describe '#default_value_for_sql' do
    subject { column_info.default_value_for_sql }

    context 'when default is nil' do
      let(:default) { nil }
      it { is_expected.to be_nil }
    end

    context 'when default is something' do
      let(:default) { 'something' }
      it { is_expected.to eq("default '#{default}'") }
    end
  end

  describe '#text_column?' do
    subject { column_info.text_column? }

    context 'when type is INT' do
      let(:type) { 'INT' }
      it { is_expected.to be_falsey }
    end

    context 'when type is VARCHAR' do
      it { is_expected.to be_truthy }
    end
  end
end
