function dt_ship_batch
% dtShip_batch(BaseDir, DataFiles, PARAMS, DetParams, varargin)
%
% Run the long time ship detection algorithm on a set of files which are
% members of the LTSA
%
% BaseDir - common prefix for all files, use '' or [] for no prefix
% DataFiles - List of files to be processed
% PARAMS - Structure representing an LTSA
%
% Optional arguments:
% 'Viewpath', {'dir1', 'dir2', ... }
%               List of directories to be viewpathed.  When searching
%               for files, each directory in the cell array is examined
%               for the file, and the first one encountered is used.
%               New files are always written relative to the first
%               directory in the viewpath.
%
% Maintained by CVS - do not modify
% $Id: dtShip_batch.m,v 1 2017/28/02 asolsonaberga
global REMORA PARAMS

% detection parameters (%%%%%%%%% parameters to add in the settings file)
% % % % REMORA.ship_dt.settings.REWavExt= '(\.x)?\.wav';   % data files must end in this regular expression
% % % % REMORA.ship_dt.settings.RELtsaExt = '.s';   % Ship - Long term detection label extension

% get detection parameters
durWind = REMORA.ship_dt.settings.durWind;
slide = REMORA.ship_dt.settings.slide;
errorRange = REMORA.ship_dt.settings.errorRange;

sec2dnum = 60*60*24; % conversion factor to get from seconds to matlab datenum
tic;  % Note start time

% Initialize
populateTimes = [];
populateLabels = {};
populateRL = [];
newperc = 0;

% Get index of files
fStart = 1;
fEnd = REMORA.ship_dt.ltsa.nrftot; % Number of raw files
cumDur = cumsum(REMORA.ship_dt.ltsa.dur)' - REMORA.ship_dt.ltsa.dur(1);
wavNames = REMORA.ship_dt.ltsahd.fname;
fileStarts = find(REMORA.ship_dt.ltsahd.rfileid == 1);
fileEnds = [fileStarts(2:end) - 1, size(REMORA.ship_dt.ltsahd.rfileid, 2)];
fileDur = arrayfun(@(x) sum(REMORA.ship_dt.ltsa.dur(1:x)),fileEnds-fileStarts+1);

% create s. files in output directory
% fn_creatTxtFiles(wavNames,REMORA.ship_dt.settings)

% how many windows will be used to process ltsa
TotalWindows = ceil(REMORA.ship_dt.ltsa.durtot/durWind);

disp('Start processing...')
fprintf('Running Ship batch detection for %d files\n',REMORA.ship_dt.ltsa.nxwav)

% sSnippet = fStart;
cumSecWind = 0;
for itr1 = 1:TotalWindows
    
    %%% Detect ships 
    % Apply detector to the central window (of size durWind) and to the
    % overlapping windows of "slide" seconds before and after start of the 
    % central window
    
    % Read the spectral data of the snippet of data and apply detector
    % Central Window
    dnumSnippet = REMORA.ship_dt.ltsa.start.dnum + datenum([0 0 0 0 0 cumSecWind]);
    pwr = fn_pwrSnippet(dnumSnippet);    
    [ships,labels,RL] = dt_ship_signal(pwr,1);
    dnumShips = ships./sec2dnum + dnumSnippet; % convert to actual times
    
    % Previous Window
    dnumPrevSnippet = dnumSnippet - datenum([0 0 0 0 0 slide]);
    
    % If earlier than start of ltsa, previous window will be the same like the central window
    if dnumPrevSnippet < REMORA.ship_dt.ltsa.start.dnum
       dnumPrevSnippet = REMORA.ship_dt.ltsa.start.dnum; 
    end
    pwr = fn_pwrSnippet(dnumPrevSnippet); 
    [shipsPrev,labelsPrev,~] = dt_ship_signal(pwr,0);
    dnumShipsPrev = shipsPrev./sec2dnum + dnumPrevSnippet; % convert to actual times
    
    % Posterior window
    dnumPostSnippet = dnumSnippet + datenum([0 0 0 0 0 slide]);
    
    % If past the end of ltsa, posterior window will be the same like the central window
    if dnumPostSnippet > REMORA.ship_dt.ltsa.end.dnum
       dnumPostSnippet = dnumSnippet; 
    end
    pwr = fn_pwrSnippet(dnumPostSnippet); 
    [shipsPost,labelsPost,~] = dt_ship_signal(pwr,0);
    dnumShipsPost = shipsPost./sec2dnum + dnumPostSnippet;
    
    
    %%% Compare overlapping windows
    % Select detections that appear at central window and at least in one
    % of the overlapping windows, if not detected in the central window
    % because is cut at the edge, get times from the overlapping window
    selectShips = [];
    selectLabels = {};
    % create combination
    comb = ~[isempty(ships) isempty(shipsPrev) isempty(shipsPost)];
    if isequal(comb,[1 1 1]) || isequal(comb,[1 1 0]) || isequal(comb,[1 0 1])
        for itr2 = 1:size(ships,1)
            if  sum([~isempty(shipsPrev) & abs(ships(itr2,1) - shipsPrev(:,1)) <= errorRange | ...
                    abs(ships(itr2,2) - shipsPrev(:,2)) <= errorRange ; ...
                    ~isempty(shipsPost) & abs(ships(itr2,1) - shipsPost(:,1)) <= errorRange | ...
                    abs(ships(itr2,2) - shipsPost(:,2)) <= errorRange])
                selectShips = [selectShips; ships(itr2,:)];
                selectLabels = [selectLabels; labels{itr2}];
            end
        end
    elseif isequal(comb,[0 1 0])
        % detection at the left edge of the window
        for itr3 = 1:size(shipsPrev,1)
            onEdge = find(shipsPrev(itr3,1) < 1 &shipsPrev(itr3,2) > 1); % start before the central window and the end in the central window
            if onEdge
                selectShips = [selectShips; zeros(1),shipsPrev(itr3,2)]; 
                selectLabels = [selectLabels; labelsPrev{itr3}];
            end
        end
    elseif isequal(comb,[0 0 1])
        % detection at the right edge of the window
        maxEnd = durWind/REMORA.ship_dt.ltsa.tave;
        for itr4 = 1:size(shipsPost,1)
            onEdge = find(shipsPost(itr4,1) <= maxEnd & shipsPost(itr4,2) > maxEnd); % the start have to be in the central window and the end passed
            if onEdge
                selectShips = [selectShips; shipsPost(itr4,1), maxEnd]; 
                selectLabels = [selectLabels; labelsPost{itr4}];
            end
        end
    else
        % no ships detected
    end

    if ~isempty(selectShips)
        %%% Convert data times to save to corresponding files
        % Raw file length can vary in length within a xwav file, make sure that it
        % gives the correct time.
        
        refStart = sum(REMORA.ship_dt.ltsa.dur(1:sSnippet-1));
        ships_s = (selectShips.*REMORA.ship_dt.ltsa.tave) + refStart; % get real sec position (index * tbin)
        sRefFile = arrayfun(@(x) find(x>=cumDur,1,'last'),ships_s(:,1));
        eRefFile = arrayfun(@(x) find(x>=cumDur,1,'last'),ships_s(:,2));
        
        % Convert all ship_s to "real" datenums
        shipRef_s = [ships_s(:,1) - cumDur(sRefFile), ships_s(:,2) - cumDur(eRefFile)]; % detection time based on start of file
        sDnum = shipRef_s(:,1)./sec2dnum + REMORA.ship_dt.ltsa.dnumStart(sRefFile)' + datenum([2000,0,0]);
        eDnum = shipRef_s(:,2)./sec2dnum + REMORA.ship_dt.ltsa.dnumStart(eRefFile)' + datenum([2000,0,0]);
        populateTimes = [populateTimes; sDnum,eDnum];
        populateLabels = [populateLabels; selectLabels];
        if ~isempty(RL)
        RL.times = selectShips;
        end
        populateRL = [populateRL;RL];
        
        for itr5 = 1: size(shipRef_s,1)
            
            %find corresponding wav files to save the detections
            sidx = sum(REMORA.ship_dt.ltsahd.rfileid(1:sRefFile(itr5)) == 1);
            eidx = sum(REMORA.ship_dt.ltsahd.rfileid(1:eRefFile(itr5)) == 1);
            
            % adjust reference time to start of wav file instead of raw
            % file
            sRefWavdur = sum(REMORA.ship_dt.ltsa.dur(1:REMORA.ship_dt.ltsahd.rfileid(sRefFile)));
            eRefWavdur = sum(REMORA.ship_dt.ltsa.dur(1:REMORA.ship_dt.ltsahd.rfileid(eRefFile)));
            
            ifiles = sidx:eidx;
            detLabel = selectLabels{itr5};
            
        end
        
    end
    
    perc = round(itr1/TotalWindows*100);
    % only text will be displayed if number increased
    if perc ~= newperc
        newperc = perc; 
        progress = [num2str(newperc),'%'];
        fprintf('   %s completed\n',progress)
    end

    sSnippet = eSnippet + 1;
    itr1 = itr1 + 1;
    cumSecWind = cumSecWind + durWind;
end

if ~isempty(populateTimes)
    shipTimes = populateTimes;
    shipLabels = populateLabels;
    shipRL = populateRL;
    
    % save all detections with real datenums in a mat file
    filename = split(REMORA.ship_dt.ltsa.infile,'.ltsa');
    matname = ['Ship_detections_',filename{1},'.mat'];
    save(fullfile(REMORA.ship_dt.settings.outDir,matname),'shipTimes',...
        'shipLabels','shipRL','-mat','-v7.3');
    fprintf('Detections saved at: %s\n',fullfile(REMORA.ship_dt.settings.outDir,matname));
    
    % save labels
    if REMORA.ship_dt.settings.saveLabels
        labelname = ['Ship_labels_',filename{1},'.tlab'];
        ioWriteLabel(fullfile(REMORA.ship_dt.settings.outDir,labelname), shipTimes - datenum([2000 0 0 0 0 0]), shipLabels, 'Binary', true);
        fprintf('Labels saved at: %s\n',fullfile(REMORA.ship_dt.settings.outDir,labelname));
    end

else
    fprintf('No detections in file: %s\n',...
        fullfile(REMORA.ship_dt.ltsa.inpath,REMORA.ship_dt.ltsa.infile))
end

fprintf('LTSA batch detection completed (%d files, processing time: %s)\n', ...
    REMORA.ship_dt.ltsa.nxwav, sectohhmmss(toc));

