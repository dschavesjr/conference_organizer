module Api
    module V1
        class PalestrasController < Api::V1::ApplicationController

            def create
                unless palestra_params[:arquivo].blank?
                    @palestras = UploadPalestrasParser.new(palestra_params[:arquivo], 'application/json').palestras

                    @palestras.each do |palestra|
                        persistir = Palestra.new(nome: palestra['nome'], tempo: palestra['tempo'].to_s == 'lightning' ? 5 : palestra['tempo'].to_i)
                        persistir.save
                    end
                end

                render json: ActiveSupport::JSON.encode(Evento.organizado), status: :ok
            end
            
            private

            def palestra_params
                params.permit(:arquivo)
            end
        end
    end
end
