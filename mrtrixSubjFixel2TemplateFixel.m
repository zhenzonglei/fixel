function mrtrixSubjFixel2TemplateFixel(dwiDir,sessid,runName,fdName)
% 17. Assign subject fixels to template fixels
% mrtrixSubjFixel2TemplateFixel(dwiDir,sessid,runName,fdName)
if nargin < 4, fdName = 'fd.mif'; end
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    templateDir = fullfile(fbaDir, runName{r},'template');
    maskDir = fullfile(templateDir,'fixel_mask');
    fdDir =  fullfile(templateDir,'fd');
   
    for s = 1:length(sessid)
        fprintf('Subj fixel to template fixel:(%s,%s)\n',sessid{s},runName{r});  
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        fdFile = fullfile(mrtrixDir,'fixel_in_template_space',fdName);
        
        fixelcorrespondence = sprintf('fixelcorrespondence -force %s %s %s %s',fdFile, maskDir,fdDir,[sessid{s},'.mif']);
        system(fixelcorrespondence);
    end
end