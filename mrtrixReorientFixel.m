function mrtrixReorientFixel(dwiDir,sessid,runName,fixelName,warpName)
% 16. Reorient fixel orientations
% mrtrixReorientFixel(dwiDir,sessid,runName,fixelName,warpName)
if nargin < 5, warpName = 'subject2template_warp.mif'; end
if nargin < 4, fixelName = 'fixel_in_template_space'; end

for r = 1:length(runName)
    for s = 1:length(sessid)
        fprintf('Reorient fixel:(%s,%s)\n',sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        warpFile = fullfile(mrtrixDir,warpName);
        
        fixelDir = fullfile(mrtrixDir,fixelName);          
        fixelreorient = sprintf('fixelreorient %s %s %s -force',fixelDir,warpFile,fixelDir);
        system(fixelreorient);
    end
end