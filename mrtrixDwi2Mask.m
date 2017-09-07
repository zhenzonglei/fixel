function mrtrixDwi2Mask(dwiDir,sessid,runName,dwiName)
% 3. Estimate a brain mask
% mrtrixDwi2Mask(dwiDir,sessid,runName,dwiName)
if nargin < 4, dwiName = 'dwi_denoised_preproc.mif'; end

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwi2mask:(%s,%s)\n',sessid{s},runName{r});
        
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = fullfile(mrtrixDir,dwiName);
        outFile = fullfile(mrtrixDir,'dwi_mask.mif');
        
        dwi2mask = sprintf('dwi2mask %s %s',inFile, outFile);
        system(dwi2mask);
        
        fprintf('dwi2mask:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end