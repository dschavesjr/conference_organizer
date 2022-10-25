class Palestra < ApplicationRecord
    validates_uniqueness_of :nome
end
