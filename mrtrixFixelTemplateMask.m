function mrtrixFixelTemplateMask(dwiDir,runName)
% 13. Compute a white matter template analysis fixel mask
% mrtrixFixelTemplateMask(dwiDir,runName)
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    fprintf('Fixel mask for %s\n',runName{r});
    templateDir = fullfile(fbaDir, runName{r},'template');
    
    % Compute a template AFD peaks fixel image
    fodTemplate = fullfile(templateDir,'fod_template.mif');
    maskTemplate = fullfile(templateDir,'mask_intersection.mif');
    fixelTemp =   fullfile(templateDir,'fixel_temp');
    fod2fixel = sprintf('fod2fixel %s -mask %s %s -peak peaks.mif -force',fodTemplate,maskTemplate,fixelTemp);
    system(fod2fixel);
    
    % Threshold the peaks fixel image:
    peak = fullfile(fixelTemp,'peaks.mif'); 
    peakMask = fullfile(fixelTemp,'mask.mif');
    mrthreshold = sprintf('mrthreshold %s -abs 0.33 %s -force',peak,peakMask);
    system(mrthreshold);
    
    % Generate an analysis voxel mask
    voxMask =  fullfile(templateDir,'voxel_mask.mif');
    fixel2voxel = sprintf('fixel2voxel %s max - | mrfilter - median %s -force', peakMask,voxMask);
    system(fixel2voxel);
    
    % remove fixel_temp
    % system (sprintf('rm -rf %s',fixelTemp));
    
    % Recompute the fixel mask using the analysis voxel mask
    fixelMask = fullfile(templateDir,'fixel_mask');
    fod2fixel = sprintf('fod2fixel -mask %s -fmls_peak_value 0.2 %s %s -force',voxMask,fodTemplate,fixelMask);
    system(fod2fixel);
end