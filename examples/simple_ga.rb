require_relative "../labamp.rb"
include Labamp
program :simple_ga do
  struct :organism, {fitness: double, genome: list(double, 3)}
  function :fitness, double, {o: organism} do
    o.genome[3]**3 - 6 * o.genome[2]**2 + 11 * o.genome[1]**1 - 6
  end


  function :has_been_swapped?, boolean, {b: boolean} do
    b == true
  end

  procedure :sort, none, {colony: list(organism)} do
    variable :colony_size, integer
    colony_size = colony.num_elements
    variable :swapped, boolean
    whilest(has_been_swapped?(swapped)) do
      variable :i, integer
      i = 1
      whilest(less_than?(i,colony_size)) do

      end
    end
  end
end
