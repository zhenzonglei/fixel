function mrtrixAverageResponse(dwiDir,sessid,runName,tissue)
% Average response from all subject
if nargin < 4, tissue = 'wm'; end
fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    inFile = [];
    for s = 1:length(sessid)
        fprintf('Average %s response from all subjects\n',tissue);
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        inFile = [inFile,' ',fullfile(mrtrixDir,sprintf('response_%s.txt',tissue))];
    end
    
    respDir = fullfile(fbaDir,runName{r},'response');
    if ~exist(respDir,'dir')
        mkdir(respDir);
    end
    
    outFile = fullfile(respDir,sprintf('group_average_response_%s.txt',tissue));
    avgresponse = sprintf('average_response %s %s',inFile,outFile);
    system(avgresponse);
    
    % copy average response to each subject        
    for s = 1:length(sessid)
        fprintf('Copy %s average_response to:(%s,%s)\n',tissue,sessid{s},runName{r});
        mrtrixDir = fullfile(dwiDir,sessid{s},runName{r},'mrtrix');
        desFile = fullfile(mrtrixDir,sprintf('group_average_response_%s.txt',tissue));      
        copyfile(outFile,desFile);
    end
end