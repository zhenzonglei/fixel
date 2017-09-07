function mrtrixDwi2Response(dwiDir,sessid,runName,dwiName)
% 6. Computing a group average response function
% mrtrixDwi2Response(dwiDir,sessid,runName,dwiName)
if nargin < 4, dwiName = 'dwi_denoised_preproc_bias_norm.mif'; end

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwi2response:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = fullfile(mrtrixDir,dwiName);
        wmFile = fullfile(mrtrixDir,'response_wm.txt');
        gmFile = fullfile(mrtrixDir,'response_gm.txt');
        csfFile = fullfile(mrtrixDir,'response_csf.txt');
        
        dwi2response = sprintf('dwi2response dhollander %s %s %s %s -force',inFile,wmFile,gmFile,csfFile);
        system(dwi2response);
        fprintf('dwi2response:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end

tissue  = {'wm','csf','gm'};
for t = 1:length(tissue)
    mrtrixAverageResponse(dwiDir,sessid,runName,tissue{t})
end
