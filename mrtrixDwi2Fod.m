function mrtrixDwi2Fod(dwiDir,sessid,runName,dwiName,maskName,wmResp,csfResp)
%  9. Fibre Orientation Distribution estimation
%   mrtrixDwi2Fod(dwiDir,sessid,runName,dwiName,maskName,wmResp,csfResp)
if nargin < 7, csfResp = 'group_average_response_csf.txt'; end
if nargin < 6, wmResp = 'group_average_response_wm.txt';end
if nargin < 5, maskName = 'dwi_mask_upsampled.mif';end
if nargin < 4, dwiName = 'dwi_denoised_preproc_bias_norm_upsampled.mif';end

% [~, dwiname] = fileparts(dwiName);
for r = 1:length(runName)
    for s = 1:length(sessid)
        tStart=tic;
        fprintf('dwi2fod:(%s,%s)\n', sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        dwiFile = fullfile(mrtrixDir,dwiName);
        wmRespFile  = fullfile(mrtrixDir,wmResp);
        wmFodFile = fullfile(mrtrixDir,'fod.mif');
        csfRespFile  = fullfile(mrtrixDir,csfResp);
        csfFodFile = fullfile(mrtrixDir,'csf.mif');
        maskFile = fullfile(mrtrixDir, maskName);
        
        dwi2fod = sprintf('dwi2fod msmt_csd %s %s %s %s %s -mask %s -force',dwiFile,wmRespFile,wmFodFile,csfRespFile,csfFodFile,maskFile);
        
        % for single shell, we need to extract the dwi data
        % dwi2fod = sprintf('dwiextract %s- \| dwi2fod msmt_csd - %s IN/fod.mif -mask %s', dwiFile,wsResp,maskFile):
        
        system(dwi2fod);
        fprintf('dwi2fod:(%s,%s)takes %.2f hours\n',sessid{s},runName{r},toc(tStart)/3600);
    end
end
