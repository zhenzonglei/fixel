function mrtrixWarpSubjFod2Template(dwiDir,sessid,runName,fodName)
% 14. Warp FOD images to template space
%  mrtrixWarpSubjFod2Template(dwiDir,sessid,runName,fodName)
if nargin < 4, fodName = 'fod.mif'; end
[~, fodname] = fileparts(fodName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Fod2template:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        fodFile = fullfile(mrtrixDir,fodName);
        warpFile = fullfile(mrtrixDir,'subject2template_warp.mif');
        outFile = fullfile(mrtrixDir,[fodname,'_in_template_space.mif']);
        
        mrtransform = sprintf('mrtransform %s -warp %s -noreorientation %s -force',fodFile,warpFile,outFile);
        system(mrtransform);
    end
end