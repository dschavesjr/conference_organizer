require 'rails_helper'

RSpec.describe Evento, type: :model do
    describe '#organizado' do
        context 'Track A & B completas' do
            before do
                @palestras = UploadPalestrasParser.new(File.open("#{Rails.root}/spec/fixtures/palestras.json"), 'application/json').palestras
                @palestras.each do |palestra|
                    persistir = Palestra.new(nome: palestra['nome'], tempo: palestra['tempo'].to_s == 'lightning' ? 5 : palestra['tempo'].to_i)
                    persistir.save
                end

                @resultado_esperado = {"A"=>[{"Nome"=>"Diminuindo tempo de execução de testes em aplicações Rails enterprise", "Hora"=>"09:00", "Tempo"=>"60min"}, {"Nome"=>"Reinventando a roda em ASP clássico", "Hora"=>"10:00", "Tempo"=>"45min"}, {"Nome"=>"Apresentando Lua para as massas", "Hora"=>"10:45", "Tempo"=>"30min"}, {"Nome"=>"Erros de Ruby oriundos de versões erradas de gems", "Hora"=>"11:15", "Tempo"=>"45min"}, {"Nome"=>"Almoço", "Hora"=>"12:00", "Tempo"=>""}, {"Nome"=>"Trabalho remoto: prós e cons", "Hora"=>"13:00", "Tempo"=>"60min"}, {"Nome"=>"Desenvolvimento orientado a gambiarras", "Hora"=>"14:00", "Tempo"=>"45min"}, {"Nome"=>"Erros comuns em Ruby", "Hora"=>"14:45", "Tempo"=>"45min"}, {"Nome"=>"Ensinando programação nas grotas de Maceió", "Hora"=>"15:30", "Tempo"=>"30min"}, {"Nome"=>"Codifique menos, Escreva mais!", "Hora"=>"16:00", "Tempo"=>"30min"}, {"Nome"=>"Aplicações isomórficas: o futuro (que talvez nunca chegaremos)", "Hora"=>"16:30", "Tempo"=>"30min"}, {"Nome"=>"Evento de Networking", "Hora"=>"17:00", "Tempo"=>""}], "B"=>[{"Nome"=>"Programação em par", "Hora"=>"09:00", "Tempo"=>"45min"}, {"Nome"=>"A mágica do Rails: como ser mais produtivo", "Hora"=>"09:45", "Tempo"=>"60min"}, {"Nome"=>"Clojure engoliu Scala: migrando ha aplicação", "Hora"=>"10:45", "Tempo"=>"45min"}, {"Nome"=>"Ruby vs. Clojure para desenvolvimento backend", "Hora"=>"11:30", "Tempo"=>"30min"}, {"Nome"=>"Almoço", "Hora"=>"12:00", "Tempo"=>""}, {"Nome"=>"Manutenção de aplicações legadas em Ruby on Rails", "Hora"=>"13:00", "Tempo"=>"60min"}, {"Nome"=>"Ruby on Rails: Por que devemos deixá-lo para trás", "Hora"=>"14:00", "Tempo"=>"60min"}, {"Nome"=>"Otimizando CSS em aplicações Rails", "Hora"=>"15:00", "Tempo"=>"30min"}, {"Nome"=>"Um mundo sem StackOverflow", "Hora"=>"15:30", "Tempo"=>"30min"}, {"Nome"=>"Rails para usuários de Django", "Hora"=>"16:00", "Tempo"=>"lightning"}, {"Nome"=>"Evento de Networking", "Hora"=>"17:00", "Tempo"=>""}]}
            end

            it 'hash palestras organizadas' do
                expect(Evento.organizado).to eq(@resultado_esperado)
            end
        end
    end
end