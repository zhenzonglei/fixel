function mrtrixReduceTemplateTractographyBias(dwiDir,runName)
% 21. Reduce biases in tractogram densities
% mrtrixReduceTemplateTractographyBias(dwiDir,runName)
currDir  = pwd;
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    tStart=tic;
    fprintf('ReduceTemplateTractographyBias %s\n',runName{r});
    
    templateDir = fullfile(fbaDir, runName{r},'template');
    cd(templateDir);
    
    tcksift = 'tcksift tracks_20_million.tck fod_template.mif tracks_2_million_sift.tck -term_number 2000000 -force';
    system(tcksift);
    
    fprintf('ReduceTemplateTractographyBias %s takes %.2f hours\n',runName{r},toc(tStart)/3600);
end
cd(currDir);