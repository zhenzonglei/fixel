function mrtrixDwiUpsample(dwiDir,sessid,runName,dwiName)
% 7. Upsampling DW images
% mrtrixDwiUpsample(dwiDir,sessid,runName,dwiName)
if nargin < 4, dwiName = 'dwi_denoised_preproc_bias_norm.mif';end
[~, dwiname] = fileparts(dwiName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwiupsample:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = fullfile(mrtrixDir,dwiName);
        
        outFile = fullfile(mrtrixDir,[dwiname,'_upsampled.mif']);
        mrresize = sprintf('mrresize %s -vox 1.25 %s -force',inFile,outFile);
        system(mrresize);
        
        fprintf('dwiupsample:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end
