function mrtrixGenerateFodTemplate(dwiDir,sessid,runName,fodName,maskName,isall)
% 10. Generate a study-specific unbiased FOD template
% mrtrixGenerateFodTemplate(dwiDir,sessid,runName,fodName, maskName)
if nargin < 6, isall = false; end
if nargin < 5, fodName='fod.mif'; end
if nargin < 4, maskName = 'dwi_mask_upsampled.mif';end

fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    tStart=tic;
    fprintf('population_template: %s\n', runName{r});
    
    templateDir = fullfile(fbaDir, runName{r},'template');
    if ~exist(templateDir,'dir')
        mkdir(templateDir);
    end
    
    fodDir = fullfile(templateDir,'fod');
    if ~exist(fodDir,'dir')
        mkdir(fodDir);
    end
    
    maskDir = fullfile(templateDir,'mask');
    if ~exist(maskDir,'dir')
        mkdir(maskDir);
    end
    
    for s = 1:length(sessid)
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        targFod = fullfile(mrtrixDir,fodName);
        linkFod = fullfile(fodDir,[sessid{s},'.mif']);
        if exist(linkFod,'file')
            delete(linkFod)
        end
        system(sprintf('ln -s %s %s',targFod,linkFod));
        
        targMask= fullfile(mrtrixDir,maskName);
        linkMask = fullfile(maskDir,[sessid{s},'.mif']);
        if exist(linkMask,'file')
            delete(linkMask)
        end
        system(sprintf('ln -s %s %s',targMask,linkMask));
    end
    
    template = fullfile(templateDir,'fod_template.mif');
    if isall
        warpDir = fullfile(templateDir,'warps');
        if ~exist(warpDir,'dir')
            mkdir(warpDir);
        end
        poptemplate = sprintf('population_template %s -mask_dir %s %s -warp_dir %s -force',fodDir,maskDir,template,warpDir);
    else
        poptemplate = sprintf('population_template %s -mask_dir %s %s -force',fodDir,maskDir,template);
    end
    
    system(poptemplate);
    fprintf('population_template %s takes %.2f hours\n',runName{r},toc(tStart)/3600);
end