function mrtrixComputeFC(dwiDir,sessid,runName)
% 18. Compute fibre cross-section (FC) metric
%  mrtrixComputeFC(dwiDir,sessid,runName)
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    templateDir = fullfile(fbaDir, runName{r},'template');
    maskDir = fullfile(templateDir,'fixel_mask');
    fcDir =  fullfile(templateDir,'fc');
    
    for s = 1:length(sessid)
        fprintf('Compute FC:(%s,%s)\n',sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        warpFile = fullfile(mrtrixDir,'subject2template_warp.mif');
        warp2metric = sprintf('warp2metric -force %s -fc %s %s %s',warpFile, maskDir,fcDir,[sessid{s},'.mif']);
        system(warp2metric);
    end
    
    
    logfcDir = fullfile(templateDir,'logfc');
    if ~exist(logfcDir,'dir')
        mkdir(logfcDir);
    end
    
    indexFile = fullfile(fcDir,'index.mif');
    dirFile = fullfile(fcDir,'directions.mif');
    system(sprintf('cp %s %s %s',indexFile, dirFile,logfcDir));
    for s = 1:length(sessid)
        fprintf('Compute logfc:(%s,%s)\n',sessid{s},runName{r});
        fc = fullfile(fcDir,[sessid{s},'.mif']);
        logfc = fullfile(logfcDir,[sessid{s},'.mif']); 
        mrcalc = sprintf('mrcalc -force %s -log %s',fc,logfc);
        system(mrcalc);
    end
end