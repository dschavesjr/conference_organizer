class Evento
    class << self
        def organizado
            grade = Palestra.all
            grade = grade.as_json(only: [:nome, :tempo])

            resultado = {}
            i = 0;
            char_code = 65 # A
            while grade.size > 0
                grade_manha, grade_tarde = [], []
                grade_manha = group_by_intervalo(grade, 180)
                grade = grade.map {|palestra| palestra unless grade_manha.include? palestra}.compact
                if grade.size > 0
                    grade_tarde = group_by_intervalo(grade, 240).sort_by { |palestra| palestra["tempo"] }.reverse
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
                cronograma["Tempo"] = ''
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
                cronograma["Tempo"] = ''
                track << cronograma
                resultado[char_code.chr] = track
                char_code += 1
            end
            resultado
        end

        private

        def group_by_intervalo(palestras, intervalo, tempo=0, i=0, result=[], max_result=[], max_tempo=0)
            return result if (tempo == intervalo || (palestras.difference(result).empty? && (tempo < intervalo)))
        
            if tempo > intervalo
                tempo -= palestras[i-1]["tempo"]
                result.delete(palestras[i-1])
            end
    
            if tempo < intervalo && tempo > max_tempo
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
            group_by_intervalo(palestras, intervalo, tempo, i+1, result, max_result, max_tempo)    
        end

        def sum_time(horas,minutos,minutos_to_sum)
            minutos += minutos_to_sum
            horas += (minutos.to_i / 60).floor
            minutos = minutos.to_i % 60
            return [horas, minutos]
        end
    end
end