require_relative "../labamp.rb"
include Labamp
program :struct_only do
  struct :organism, {fitness: double, genome: list(double, 3)}
  function :fitness, double, {o: organism} do
    o.genome[3]**3 - 6 * o.genome[2]**2 + 11 * o.genome[1]**1 - 6
  end


  function :has_been_swapped?, boolean, {b: boolean} do
    b == true
  end
end
