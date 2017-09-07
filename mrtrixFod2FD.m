function mrtrixFod2FD(dwiDir,sessid,runName,fodName,maskName)
% 15. Segment FOD images to estimate fixels and their fibre density (FD)
% mrtrixFod2FD(dwiDir,sessid,runName,fodName,maskName)
if nargin < 5, maskName = 'voxel_mask.mif'; end
if nargin < 4, fodName = 'fod_in_template_space.mif'; end
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    maskFile = fullfile(fbaDir,runName{r},'template',maskName);
    for s = 1:length(sessid)
        fprintf('Fod2Fd:(%s,%s)\n',sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        fodFile = fullfile(mrtrixDir,fodName);
        fixelDir = fullfile(mrtrixDir,'fixel_in_template_space');        
        fod2fixel = sprintf('fod2fixel %s -mask %s %s -afd fd.mif -force',fodFile,maskFile,fixelDir);
        system(fod2fixel);
    end
end