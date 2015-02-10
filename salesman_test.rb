require 'ruby-jgap'

$table = {
  A: [0, 0],
  B: [1, 1],
  C: [2, 2],
  D: [3, 3],
  E: [4, 4],
  F: [5, 5],
  G: [6, 6],
  H: [7, 7],
  I: [8, 8]
}

class TSP < JGAP::Salesman
  
  population_size 1000

  # define our solution chromosome
  chromosome do
    salesman [:A, :B, :C, :D, :E, :F, :G, :H, :I]
  end
  
  def distance_function(from, to)
    x1, y1 = $table[get_name from]
    x2, y2 = $table[get_name to]
    Math.sqrt((x1 - x2)**2 + (y1-y2)**2)
  end
  
end

tsp = TSP.new
tsp.run
tsp.print_best
p tsp.best_solution.fitness_value
