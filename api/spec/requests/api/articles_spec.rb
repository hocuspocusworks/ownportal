describe Api::ArticlesController, type: :controller do
  let_it_be(:user)      { create(:user) }
  let_it_be(:source)    { create(:source, creator: user) }
  let_it_be(:group)     { create(:group, user:) }
  let_it_be(:stream)    { create(:stream, user:, group:, source:) }
  let_it_be(:articles)  { create_list(:article, 35, source:) }
  let(:body)            { JSON.parse(response.body) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authenticate).and_return(true)
  end

  describe '#paginable' do
    context 'with first page and offset' do
      let(:params) { { page: 1, offset: 10, source: source.id } }

      it 'shows first 10 articles' do
        get :index, params: params

        expect(response.status).to eq(200)
        expect(body.size).to eq(10)
        expect(body.first['id']).to eq(1)
        expect(body.last['id']).to eq(10)
      end
    end

    context 'with second page and non default offset' do
      let(:params) { { page: '2', offset: 20, source: source.id } }

      it 'shows last articles' do
        get :index, params: params

        expect(response.status).to eq(200)
        expect(body.size).to eq(15)
        expect(body.first['id']).to eq(21)
        expect(body.last['id']).to eq(35)
      end
    end

    context 'with incorrect page and offset' do
      let(:params) { { page: 'string', offset: 10, source: source.id } }

      it 'shows first 10 articles' do
        get :index, params: params

        expect(response.status).to eq(200)
        expect(body.size).to eq(10)
        expect(body.first['id']).to eq(1)
        expect(body.last['id']).to eq(10)
      end
    end

    context 'with correct page and incorrect offset' do
      let(:params) { { page: '1', offset: 'wrong', source: source.id } }

      it 'shows first max_offset articles' do
        get :index, params: params

        expect(response.status).to eq(200)
        expect(body.size).to eq(30)
        expect(body.first['id']).to eq(1)
        expect(body.last['id']).to eq(30)
      end
    end

    context 'with group' do
      let(:params) { { page: '1', offset: '10', group: group.id } }

      it 'shows first 10 articles' do
        get :index, params: params

        expect(response.status).to eq(200)
        expect(body.size).to eq(10)
        expect(body.first['id']).to eq(1)
        expect(body.last['id']).to eq(10)
      end
    end
  end
end
