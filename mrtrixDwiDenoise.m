function mrtrixDwiDenoise(dwiDir,sessid,runName,dwiName)
% Convert a dwi,bevc, bval to a mrtrix .mif image.
if nargin < 4, dwiName = 'dwi.mif'; end
[~, dwiname] = fileparts(dwiName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        tStart=tic;
        fprintf('dwidenoise:(%s,%s)\n', sessid{s},runName{r});
        
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        dwiFile = fullfile(mrtrixDir,dwiName);
        outFile = fullfile(mrtrixDir,[dwiname, '_denoised.mif']);
        noiseFile =  fullfile(mrtrixDir,'noise.mif');
        dwidenoise = sprintf('dwidenoise %s %s -noise %s',dwiFile,outFile,noiseFile);
        system(dwidenoise);
        
        % calculate the residule
        % resFile =  fullfile(mrtrixDir,'res.mif');
        % mrcalc =  sprintf('mrcalc %s %s -subtract %s',dwiFile,outFile,resFile);
        % system(mrcalc);
        
        fprintf('dwidenoise:(%s,%s) takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end