% script for looping over all hier data for calculations
function runall_cost(topdir, track, setparas)

paths.topdir = topdir;
paths.matlab = strcat(topdir, '/src/matlab');
paths.ibamr = strcat(topdir, '/results/ibamr/',track,'_runs/');
paths.parameter = strcat(topdir, '/data/parameters/');
paths.results = strcat(topdir, '/results/matlab-csv-files/',track,'_results/');

allpara = load(strcat(paths.parameter, 'allpara_',num2str(setparas),'.txt'));

n = length(allpara);
%n=3;
cost = zeros(n,2);

for run = 1:n
    
    if allpara(run, 3)<=0.7 
        endtime=350000;
    elseif allpara(run,3)<1.0
        endtime=300000;
    else
        endtime=250000;
    end
    
    [cost(run, 1), cost(run, 2)] = compute_Work_and_Cost_Of_Transport(paths, run, endtime);
    

    
end
mkdir(paths.results)
csvwrite(strcat(paths.results, 'cost_of_transport_',num2str(n),'_',date,'.csv'),cost)
end
