require 'ruby-jgap'

$table = [
  [0, 0],
  [-1, 1],
  [-7, -1],
  [-8, -2],
  [2, -1],
  [10, 2],
  [7, -1]
]

class TSP < JGAP::Salesman
  
  population_size 100000

  # define our solution chromosome
  chromosome do
    salesman :paris, 7
    salesman :london, 7
    salesman :new_york, 7
    salesman :boston, 7
    salesman :berlin, 7
    salesman :tokyo, 7
    salesman :shanghai, 7
  end
  
  def distance(from, to)
    f = from.allele
    t = to.allele
    x1, y1 = $table[f]
    x2, y2 = $table[t]
    
    Math.sqrt((x1 - x2)**2 + (y1-y2)**2)
  end
  
end

tsp = TSP.new
tsp.run
tsp.print_best
p tsp.best_solution.fitness_value
