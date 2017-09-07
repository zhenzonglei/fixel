function mrtrixDwi2Mif(dwiDir,sessid,runName)
% 0,Convert a dwi,bevc, bval to a mrtrix .mif image.

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwi2mif:(%s,%s)\n', sessid{s},runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        mrtrixDir = fullfile(runDir, 'mrtrix');
        
        % remove old dir
        if exist(mrtrixDir,'dir')
            rmdir(mrtrixDir,'s');
        end
        
        % make new dir
        if ~exist(mrtrixDir,'dir')
            mkdir(mrtrixDir);
        end
        
        fstr = runName{r}(end-3:end);
        dwiFile = fullfile(runDir,'raw',[fstr,'.nii.gz']);
        gradFile =   fullfile(runDir,'raw','grad.b');
        mifFile = fullfile(runDir,'mrtrix','dwi.mif');

        % bvecFile = fullfile(runDir,'raw',[fstr,'.bvec']);
        % bvalFile = fullfile(runDir,'raw',[fstr,'.bval']);
        % mrconvert = sprintf('mrconvert %s -fslgrad %s %s %s',dwiFile, bvecFile, bvalFile, mifFile);

        mrconvert = sprintf('mrconvert %s -grad %s %s',dwiFile, gradFile, mifFile);        
        system(mrconvert);
        fprintf('dwi2mif:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end