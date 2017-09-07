function mrtrixFixelStatisticalAnalysis(dwiDir,runName,designName,metric)
% do statistical analysis on FBA metric.
if nargin < 4, metric = {'fd','logfc','fdc'}; end

contrastFile = [designName, '_contrast.txt'];
designFile = [designName, '_design.txt'];
dataFile = [designName,'_data.txt'];
currDir  = pwd;

fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    templateDir = fullfile(fbaDir, runName{r},'template');
    cd(templateDir);
    for i = 1:length(metric)
        tStart=tic;
        fprintf('fixelcfestats (%s,%s)\n', runName{r},metric{i});
        cmd = sprintf('fixelcfestats %s %s %s %s tracks_2_million_sift.tck %s_stats_%s -negative -force',metric{i},dataFile, designFile,contrastFile,designName,metric{i}) ;
        system(cmd);
        fprintf('fixelcfestats (%s,%s) takes %.2f hours\n',runName{r},metric{i},toc(tStart)/3600);
    end
end
cd(currDir);