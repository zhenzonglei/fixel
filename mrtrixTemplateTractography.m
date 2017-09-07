function mrtrixTemplateTractography(dwiDir,runName)
% 20. Perform whole-brain fibre tractography on the FOD template
% mrtrixTemplateTractography(dwiDir,runName)
currDir = pwd;
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    tStart=tic;
    fprintf('tckgen %s\n',runName{r});
    
    templateDir = fullfile(fbaDir, runName{r},'template');
    cd(templateDir);
    tckgen = 'tckgen -angle 22.5 -maxlen 250 -minlen 10 -power 1.0 fod_template.mif -seed_image voxel_mask.mif -mask voxel_mask.mif -select 20000000 -force tracks_20_million.tck';
    system(tckgen);
    
    fprintf('tckgen %s takes %.2f hours\n',runName{r},toc(tStart)/3600);
end
cd(currDir);