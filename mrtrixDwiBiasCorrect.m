function mrtrixDwiBiasCorrect(dwiDir,sessid,runName,dwiName,maskName)
% 4. Bias field correction
%  mrtrixDwiBiasCorrect(dwiDir,sessid,runName,dwiName,maskName)
if nargin < 5, maskName = 'dwi_mask.mif';end
if nargin < 4, dwiName = 'dwi_denoised_preproc.mif'; end
[~, dwiname] = fileparts(dwiName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwibiascorrect:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = fullfile(mrtrixDir,dwiName);
        maskFile = fullfile(mrtrixDir,maskName);
        outFile = fullfile(mrtrixDir,[dwiname, '_bias.mif']);
        
        dwibiascorrect = sprintf('dwibiascorrect -ants -mask %s %s %s -nocleanup -tempdir %s',...
            maskFile,inFile,outFile,mrtrixDir);
        system(dwibiascorrect);
        
        fprintf('dwibiascorrect:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end