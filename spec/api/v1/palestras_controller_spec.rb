require 'rails_helper'

RSpec.describe 'Api::V1::Palestras', type: :request do
    describe '#create' do
        context 'correct' do
            before do
                post '/api/v1/palestras', params: {
                 arquivo: [{nome: 'Teste', tempo: 30}, {nome: 'Teste 2', tempo: 60}]
                }
            end

            it 'return status ok' do
                expect(response.status).to eq(200)
            end
        end
    end
end