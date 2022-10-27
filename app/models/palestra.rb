class Palestra < ApplicationRecord
    validates_uniqueness_of :nome
    validates_numericality_of :tempo, greater_than: 0
end
