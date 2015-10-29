module Master
  class Utils
    def self.distribute_adults_and_kids(rooms, adults, kids)
      dist = {}
      dist[:adults] = [0] * rooms
      adults.times{|i| dist[:adults][i.modulo(rooms)] += 1 }
      dist[:kids] = []
      rooms.times{|i| dist[:kids] << []}
      kids.times{|i| dist[:kids][i.modulo(rooms)] << 7 }
      dist
    end
  end
end