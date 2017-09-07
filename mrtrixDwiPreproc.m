function mrtrixDwiPreproc(dwiDir,sessid,runName,dwiName)
% 2. DWI general pre-processing
%  mrtrixDwiPreproc(dwiDir,sessid,runName,dwiName)
if nargin < 4, dwiName = 'dwi_denoised.mif'; end
[~, dwiname] = fileparts(dwiName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwipreproc:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = fullfile(mrtrixDir,dwiName);
        outFile = fullfile(mrtrixDir,[dwiname, '_preproc.mif']);
        dwipreproc = sprintf('dwipreproc %s %s -rpe_none -pe_dir AP -nocleanup -tempdir %s',...
            inFile, outFile,mrtrixDir);
        system(dwipreproc);
        
        fprintf('dwipreproc:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end