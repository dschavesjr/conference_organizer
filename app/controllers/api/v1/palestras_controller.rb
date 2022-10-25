module Api
    module V1
        class PalestrasController < Api::V1::ApplicationController

            def create
                unless palestra_params[:arquivo].blank?
                    if palestra_params[:arquivo].is_a?(ActionDispatch::Http::UploadedFile)
                        @palestras = UploadPalestrasParser.new(palestra_params[:arquivo], 'application/json').palestras
                    else
                        file = File.new(
                        "#{Rails.root}/tmp/#PalestrasJSON-WS-#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}.json", 'w'
                        )
                        file.puts(palestra_params[:arquivo])
                        file.close
                        @palestras = UploadPalestrasParser.new(File.open(file), 'application/json').palestras
                    end
                    @palestras.each do |palestra|
                        persistir = Palestra.new(nome: palestra['nome'], tempo: palestra['tempo'].to_s == 'lightning' ? 5 : palestra['tempo'].to_i)
                        persistir.save
                    end
                end

                grade = Palestra.all
                grade = grade.as_json(only: [:nome, :tempo])

                grade_manha, grade_tarde = [], []
                resultado = {}
                i = 0;
                char_code = 65 # A
                while grade.size > 0
                    grade_manha = group_by_target_time(grade, 180)
                    grade = grade.map {|palestra| palestra unless grade_manha.include? palestra}.compact
                    if grade.size > 0
                        grade_tarde = group_by_target_time(grade, 240).sort_by { |palestra| palestra["tempo"] }.reverse
                        grade = grade.map {|palestra| palestra unless grade_tarde.include? palestra}.compact
                    end
                    track = []
                    cronograma = {}
                    time = [9,0]
                    grade_manha.each do |palestra|
                        cronograma["Nome"] = palestra["nome"]
                        cronograma["Hora"] = format("%02d:%02d", time[0], time[1])
                        cronograma["Tempo"] = palestra['tempo'] == 5 ? 'lightning' : palestra['tempo'].to_s + "min"
                        time = sum_time(time[0],time[1],palestra['tempo'])
                        track << cronograma.clone
                    end
                    cronograma["Nome"] = 'Almoço'
                    cronograma["Hora"] = '12:00'
                    track << cronograma.clone
                    time = [13,0]
                    grade_tarde.each do |palestra|
                        cronograma["Nome"] = palestra["nome"]
                        cronograma["Hora"] = format("%02d:%02d", time[0], time[1])
                        cronograma["Tempo"] = palestra['tempo'] == 5 ? 'lightning' : palestra['tempo'].to_s + "min"
                        time = sum_time(time[0],time[1],palestra['tempo'])
                        track << cronograma.clone
                    end
                    cronograma["Nome"] = 'Evento de Networking'
                    cronograma["Hora"] = '17:00'
                    track << cronograma
                    resultado[char_code.chr] = track
                    char_code += 1
                end

                render json: ActiveSupport::JSON.encode(resultado), status: :ok
            end
            
            # rescue StandardError => e
            #     render json: e.to_json, status: e.status if e.is_a?(RequestError)

            #     if e.is_a?(JSON::ParserError)
            #         render json: ActiveSupport::JSON.encode({ message: e.message, status: 400 }), status: :bad_request
            #     end

            #     raise RequestError.new('Erro interno do servidor', 500)
            # end
            
            private

            def group_by_target_time(palestras, target_time, tempo=0, i=0, result=[], max_result=[], max_tempo=0)
                return result if (tempo == target_time || palestras.difference(result).empty?)
            
                if tempo > target_time
                  tempo -= palestras[i-1]["tempo"]
                  result.delete(palestras[i-1])
                end
          
                if tempo < target_time && tempo > max_tempo
                  max_result = result.clone
                  max_tempo = tempo
                end
            
                while i >= palestras.size
                  return max_result if result.size == 1 && (palestras.index(result[1]) == palestras.size - 1)
                  i = palestras.index(result.pop) + 1
                  tempo -= palestras[i-1]["tempo"]
                end
            
                tempo += palestras[i]["tempo"]
                result << palestras[i]
                group_by_target_time(palestras, target_time, tempo, i+1, result, max_result, max_tempo)    
            end

            def sum_time(hours,minutes,minutes_to_sum)
                minutes += minutes_to_sum
                hours += (minutes.to_i / 60).floor
                minutes = minutes.to_i % 60
                return [hours, minutes]
            end

            def palestra_params
                params.permit(:arquivo)
            end
        end
    end
end
