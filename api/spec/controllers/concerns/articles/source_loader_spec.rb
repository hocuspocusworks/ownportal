require 'rails_helper'

RSpec.describe Articles::SourceLoader, type: :model do
  # include_context :with_cache

  # let_it_be(:user) { create(:user) }

  # let!(:source) { create(:source, creator: user) }
  # let!(:article_one) { create(:article, title: 'title1', source:) }
  # let(:source_ids) { [1, 2] }

  # let(:loader) { described_class.new(source.id) }

  # describe 'load articles' do
  #   context 'with one article' do
  #     it 'has one article' do
  #       expect(loader.call).to eq([article_one])
  #     end
  #   end

  #   context 'with added article but no source update' do
  #     it 'has one articles' do
  #       allow(Rails.cache).to receive(:fetch).and_yield

  #       loader.call
  #       create(:article, title: 'title1', source:)
  #       loader.call

  #       expect(Rails.cache).to have_received(:fetch).once
  #     end
  #   end

  #   context 'with added article and source update' do
  #     it 'has two articles' do
  #       allow(Rails.cache).to receive(:fetch).and_yield

  #       loader.call
  #       create(:article, title: 'title1', source:)
  #       source.update(updated_at: Time.zone.now)
  #       loader.call

  #       expect(Rails.cache).to have_received(:fetch).twice
  #     end
  #   end
  # end
end
