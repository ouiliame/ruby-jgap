require 'java'
require 'java/jgap.jar'

java_import %w(
  org.jgap.impl.DefaultConfiguration
  org.jgap.impl.IntegerGene
  org.jgap.impl.BooleanGene
  org.jgap.impl.MapGene
  org.jgap.impl.StringGene
  org.jgap.impl.DoubleGene
  org.jgap.Chromosome
  org.jgap.Genotype
)

module JGAP
  
  class ChromosomeBuilder
    
    attr_reader :names
    attr_reader :genes
    
    def initialize(config)
      @config = config
      @names = Hash.new
      @genes = Array.new
    end
    
    def chromosome
      Chromosome.new(@config, @genes.to_java(Java::OrgJgap::Gene))
    end
    
    def read(subject, name)
      subject.gene(@names[name]).allele
    end
    
    def integer(name, opts={})
      @names[name] = @genes.length
      unless opts.empty?
        @genes << IntegerGene.new(@config, opts[:min], opts[:max])
      else
        @genes << IntegerGene.new(@config)
      end
    end
    
    def decimal(name, opts={})
      @names[name] = @genes.length
      unless opts.empty?
        @genes << DoubleGene.new(@config, opts[:min], opts[:max])
      else
        @genes << DoubleGene.new(@config)
      end
    end
    
    def boolean(name)
      @names[name] = @genes.length
      @genes << BooleanGene.new(@config)
    end
    
    def string(name, opts={})
      @names[name] = @genes.length
      if !opts.empty? && opts[:alphabet]
        @genes << StringGene.new(@config,
          opts[:min], opts[:max], opts[:alphabet])
      elsif opts
        @genes << StringGene.new(@config, opts[:min], opts[:max])
      else
        @genes << StringGene.new(@config)
      end
    end
    
  end
  
  
  ####
  
  class Problem < org.jgap.FitnessFunction
    
    attr_reader :best_solution
    
    def initialize
      @config = DefaultConfiguration.new
      @chromosome = nil
      @population_size = 0
      @population = nil
      @best_solution = nil
      @builder = ChromosomeBuilder.new(@config)
    end
  
    
    def setup
      # Override me!
    end
    
    def run(cycles=1)
      chromosome
      population_size
      @config.set_fitness_function(self)
      @config.set_sample_chromosome(@chromosome)
      @config.set_population_size(@population_size)
      @population = Genotype.random_initial_genotype(@config)
      @population.evolve(cycles)
      @best_solution = @population.get_fittest_chromosome
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
      end
    end
    
    def self.chromosome(&block)
      define_method(:chromosome) do
        @builder.instance_eval(&block)
        @chromosome = @builder.chromosome
      end
    end
    
    def self.fitness_function(&block)
      define_method(:evaluate, &block)
    end
    
  end
  
end