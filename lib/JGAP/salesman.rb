java_import %w(
  org.jgap.impl.DefaultConfiguration
  org.jgap.impl.IntegerGene
  org.jgap.impl.BooleanGene
  org.jgap.impl.MapGene
  org.jgap.impl.StringGene
  org.jgap.impl.DoubleGene
  org.jgap.Chromosome
  org.jgap.Genotype
  org.jgap.Configuration
)

module JGAP
  
  class ChromosomeBuilder

    def salesman(names)
      names.each do |name|
        new_gene = IntegerGene.new(@config, 0, names.length)
        new_gene.set_allele java.lang.Integer.new(@genes.length)
        @names[name] = @genes.length
        @genes << new_gene
      end
    end
    
    def get_name(num)
      @names.invert[num]
    end
    
  end
  
  class Salesman < org.jgap.impl.salesman.Salesman
    attr_reader :best_solution
    
    def initialize
      super
      @config = create_configuration(nil)
      @chromosome = nil
      @population_size = 512
      @builder = ChromosomeBuilder.new(@config)
      @best_solution = nil
      chromosome
      population_size
    end
    
    def distance(from, to)
      distance_function(from.allele, to.allele)
    end
    
    def get_name(num)
      @builder.get_name(num)
    end
    
    def setup
      # Override me!
    end
    
    def best_solution
      @best_solution
    end
    
    def run
      Configuration.reset
      @best_solution = find_optimal_path(nil)
    end
    
    def read(subject, name)
      @builder.read(subject, name)
    end
    
    def read_best(name)
      read(best_solution, name)
    end
    
    def print_best
      @builder.names.each do |k, v|
        puts "#{k}: #{read_best k}"
      end
    end
    
    ## MACROS
    
    def self.population_size(size)
      define_method(:population_size) do
        @population_size = size
        set_population_size(@population_size)
        @config.set_population_size(@population_size)
      end
    end
    
    def self.chromosome(&block)
      define_method(:chromosome) do
        @builder.instance_eval(&block)
        @chromosome = @builder.chromosome
      end
      
      define_method(:createSampleChromosome) do |init_data|
        @chromosome
      end
    end

    
  end
  
end
