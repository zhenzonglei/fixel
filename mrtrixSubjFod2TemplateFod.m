function mrtrixSubjFod2TemplateFod(dwiDir,sessid,runName,fodName, maskName,isWarpedInTempGen)
% 11. Register all subject FOD images to the FOD template
if nargin < 6, isWarpedInTempGen = false; end
if nargin < 5, fodName= 'fod.mif'; end
if nargin < 4, maskName = 'dwi_mask_upsampled.mif';end

fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    templateDir  = fullfile(fbaDir,runName{r},'template');
    fodTemplate = fullfile(templateDir,'fod_template.mif');
    
    if isWarpedInTempGen
        % conert warp to 4d
        for s = 1:length(sessid)
            tStart=tic;
            fprintf('warpconvert:(%s,%s)\n', sessid{s},runName{r});
           
            inWarp = fullfile(templateDir,'warps',[sessid{s},'2template_wrap.mif']);
            mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
            outWarp =  fullfile(mrtrixDir,'subject2template_warp.mif');
            warpconvert = sprintf('warpconvert -type warpfull2deformation -template  %s %s %s -force',template, inWarp,outWarp);
            system(warpconvert)
            
            fprintf('warpconvert:(%s,%s)takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
        end
    else
        for s = 1:length(sessid)
            tStart=tic;
            fprintf('mrregister:(%s,%s)\n', sessid{s},runName{r});
            
            mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
            fodFile = fullfile(mrtrixDir,fodName);
            maskFile = fullfile(mrtrixDir,maskName);
            
            subj2temp = fullfile(mrtrixDir,'subject2template_warp.mif');
            temp2subj = fullfile(mrtrixDir,'template2subject_warp.mif');
            mrregister = sprintf('mrregister %s -mask1 %s %s -nl_warp %s %s -force',fodFile,maskFile,fodTemplate,subj2temp,temp2subj);
            system(mrregister);
            
            fprintf('mrregister:(%s,%s)takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
        end
    end
end