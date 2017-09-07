function mrtrixDwiTemplateMask(dwiDir,sessid,runName,maskName)
% 12. Compute the intersection of all subject masks in template space
% mrtrixDwiTemplateMask(dwiDir,sessid,runName,maskName)
if nargin < 4, maskName = 'dwi_mask_upsampled.mif'; end

fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)        
    inMask = [];
    for s = 1:length(sessid)
        tStart = tic;
        fprintf('dwiTemplateMask:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        
        inFile = fullfile(mrtrixDir,maskName);
        outFile = fullfile(mrtrixDir,'dwi_mask_in_tempate_space.mif');
        warpFile =  fullfile(mrtrixDir,'subject2template_warp.mif');
        
        mrtransform = sprintf('mrtransform %s -warp %s -interp nearest %s',inFile,warpFile, outFile);
        system(mrtransform);
        
        inMask = [inMask, ' ', outFile];
        
        fprintf('dwiTemplateMask:(%s,%s)takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
    
    % Compute the intersection of all warped masks
    groupMask = fullfile(fbaDir, runName{r},'template','mask_intersection.mif');
    mrmath = sprintf('mrmath %s min %s', inMask, groupMask);
    system(mrmath);
end