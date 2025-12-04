function Reset

persistent check; 
if isempty(check)
clear
close_system("Workshop_as_sim_part1.mdl",0)
open_system("Workshop_as_sim_part2.mdl")
check = true;
end
end