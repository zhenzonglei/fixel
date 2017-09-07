function mrtrixIntNorm(dwiDir,sessid,runName,dwiName,maskName)
% 5. Global intensity normalisation across subjects
% mrtrixIntNorm(dwiDir,sessid,runName,dwiName,maskName)
if nargin < 5, maskName = 'dwi_mask.mif'; end
if nargin < 4, dwiName = 'dwi_denoised_preproc_bias.mif'; end

[~, dwiname] = fileparts(dwiName);
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    tStart=tic;
    fprintf('dwiIntNorm: %s\n', runName{r});
    intnormDir = fullfile(fbaDir, runName{r},'intnorm');
    if ~exist(intnormDir,'dir')
        mkdir(intnormDir);
    end
    
    dwirawDir = fullfile(intnormDir,'dwi');
    if ~exist(dwirawDir,'dir')
        mkdir(dwirawDir);
    end
    
    maskDir = fullfile(intnormDir,'mask');
    if ~exist(maskDir,'dir')
        mkdir(maskDir);
    end
    
    dwinormDir = fullfile(intnormDir,'dwinorm');
    
    % link each subject dwi data to intnorm dir
    for s = 1:length(sessid)
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        targDwi = fullfile(mrtrixDir,dwiName);
        linkDwi = fullfile(dwirawDir,[sessid{s},'.mif']);       
        if exist(linkDwi,'file')
            delete(linkDwi)
        end
        system(sprintf('ln -s %s %s',targDwi,linkDwi));
        
        targMask= fullfile(mrtrixDir,maskName);
        linkMask = fullfile(maskDir,[sessid{s},'.mif']);
        if exist(linkMask,'file')
            delete(linkMask)
        end
        system(sprintf('ln -s %s %s',targMask,linkMask));
    end
    
    % do int norm
    dwiintensitynorm = sprintf('dwiintensitynorm %s %s %s %s/fa_template.mif %s/fa_template_wm_mask.mif -nocleanup -force -tempdir %s -fa_threshold 0.25',...
        dwirawDir,maskDir,dwinormDir,dwinormDir,dwinormDir,intnormDir);
    system(dwiintensitynorm);
    
    
    % link norm data back to each subject
    for s = 1:length(sessid)
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        targDwi = fullfile(dwinormDir,[sessid{s},'.mif']);
        linkDwi = fullfile(mrtrixDir,[dwiname,'_norm.mif']);
        if exist(linkDwi,'file')
            delete(linkDwi)
        end
        system(sprintf('ln -s %s %s',targDwi,linkDwi));
    end
    fprintf('dwiIntNorm %s takes %.2f hours\n',runName{r},toc(tStart)/3600); 
end