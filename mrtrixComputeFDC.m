function mrtrixComputeFDC(dwiDir,sessid,runName)
% 19. Compute a combined measure of fibre density and cross-section (FDC)
% mrtrixComputeFDC(dwiDir,sessid,runName)
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    templateDir = fullfile(fbaDir, runName{r},'template');
    fcDir =  fullfile(templateDir,'fc');
    fdDir =  fullfile(templateDir,'fd');
    fdcDir = fullfile(templateDir,'fdc');
    if ~exist(fdcDir,'dir')
        mkdir(fdcDir);
    end
    
    indexFile = fullfile(fcDir,'index.mif');
    dirFile = fullfile(fcDir,'directions.mif');
    system(sprintf('cp %s %s %s',indexFile, dirFile,fdcDir));
    for s = 1:length(sessid)
        fprintf('Compute FDC:(%s,%s)\n',sessid{s},runName{r});
        fd = fullfile(fcDir,[sessid{s},'.mif']);
        fc = fullfile(fdDir,[sessid{s},'.mif']); 
        fdc = fullfile(fdcDir,[sessid{s},'.mif']);
        mrcalc = sprintf('mrcalc -force %s %s -mult %s',fd,fc,fdc);
        system(mrcalc);
    end
end