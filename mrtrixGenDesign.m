function mrtrixGenDesign(dwiDir,sessid,runName,analysisName,gSubjNum,covariate,model)
% gSubjNum should be a vector with length as number of groups.
% the sum of the vector should be equal to the length of sessid.
% covariate should have the same length with sessid

if nargin < 7, model = 'dods'; end
if nargin < 6, covariate = []; end
nSubj = length(sessid);

if sum(gSubjNum) ~= nSubj
    error('The sum of gSubjNum should be the total number of subject');
elseif ~isempty(covariate)
    if length(covariate) ~= nSubj
        error('The length of covariate should be equal to the length of sessid');
    end
end

fbaDir = fullfile(dwiDir,'FBA');
for r = 1:length(runName)
    analysisDir = fullfile(fbaDir, runName{r},'template',analysisName);
    if ~exist(analysisDir, 'dir')
        mkdir(analysisDir)
    end
    
    % save datafiles.txt
    datafile = fullfile(analysisDir,'data.txt');
    fid = fopen(datafile,'w+');
    for s = 1:length(sessid)
        fprintf(fid, '%s.mif\n',sessid{s});
    end
    fclose(fid);
  
    % Make design matrix for discrete variate
    nG = length(gSubjNum);
    XD = zeros(nSubj,nG);
    s = 0;
    for g = 1:nG
        e = s+gSubjNum(g);
        s = s+1;
        XD(s:e,g) = 1;
        s = e;
    end
    
     % Make design matrix for continuous variate
    if strcmp(model,'dods')
        XC = zeros(nSubj,nG);
        s=0;
        for g = 1:nG
            e = s+gSubjNum(g);
            s = s+1;
            XC(s:e,g) =  covariate(s:e);
            s = e;
        end
    else
        XC = covariate; 
    end
    
    
    % merge covariate
    X = [XD, XC];

    % save design.txt    
    fmt = [repmat('%d ',1,nG), repmat('%.2f ',1,size(XC,2)),'\n'];
    designfile = fullfile(analysisDir,'design.txt');
    fid = fopen(designfile,'w+');
    for s = 1:length(sessid)
        fprintf(fid, fmt, X(s,:));
    end
    fclose(fid);
end