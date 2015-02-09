# ruby-jgap

A Ruby DSL for Genetic Algorithms using JGAP.

The JGAP binary JAR file is packaged with this gem.

JGAP is licensed under the GNU Lesser Public license; if you would like to use this gem in commercial applications, you can choose to use the Mozilla Public License and donate 50 euros to JGAP. [more details](http://jgap.sourceforge.net/#documentation)

## Install

    gem install ruby-jgap

or

    jruby -S gem install ruby-jgap

### Usage

```ruby

require 'java'
require 'ruby-jgap'

# subclass JGAP::Problem
class MakeChangeProblem < JGAP::Problem

  population_size 500

  # define our solution chromosome
  chromosome do
    integer :quarters, min: 0, max: 3
    integer :dimes, min: 0, max: 2
    integer :nickels, min: 0, max: 1
    integer :pennies, min: 0, max: 4
  end

  # define our fitness function
  fitness_function do |subject|
    target = 47 # goal: 47 cents
    q = read subject, :quarters
    d = read subject, :dimes
    n = read subject, :nickels
    p = read subject, :pennies
    
    coins = q + d + n + p
    value = 25*q + 10*d + 5*n + p
    delta = (target - value).abs # how far are we from our goal?
    
    fitness = (99 - delta)
    fitness += 100 - (10*coins) if value == target # reward if matches with goal
    return fitness
  end


end

problem = MakeChangeProblem.new
problem.run(100) # 100 generations
problem.print_best

```

This outputs (probably):

```
quarters: 1
dimes: 2
nickels: 0
pennies: 2
```

Adapted from the [Getting Started](http://jgap.sourceforge.net/doc/tutorial.html) page on JGAP's site.
