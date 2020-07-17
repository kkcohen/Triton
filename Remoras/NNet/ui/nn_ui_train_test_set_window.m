function nn_ui_train_test_set_window(hObject,eventdata)

global REMORA

if ~isfield(REMORA.nn,'train_test_set')
    nn_ui_init_train_test_set
end

defaultPos = [0.35,.40,.45,.25];
initAxes = 0;
if isfield(REMORA.fig, 'nn')
    % check if the figure already exists. If so, don't move it.
    if isfield(REMORA.fig.nn, 'nn_train_test_set') && isvalid(REMORA.fig.nn.nn_train_test_set.figH)
        defaultPos = get(REMORA.fig.nn.nn_train_test_set.figH,'Position');
    else
        initAxes = 1;
    end
else 
    initAxes = 1;
end



if initAxes
    REMORA.fig.nn.nn_train_test_set.figH = figure;
    
    set(REMORA.fig.nn.nn_train_test_set.figH,...
        'Units','normalized',...
        'ToolBar', 'none',...
        'MenuBar','none',...
        'NumberTitle','off','Name',...
        'Neural Net Tool - v1.0: Train/Test Set options',...
        'Position',defaultPos,...
        'Visible','on');
end

clf

% get help strings for tooltips
REMORA.nn.nn_ui_help = nn_ui_get_help_strings;

% Title
labelStr = 'Train and Test Set Options';
btnPos=[0 .9 1 .1];
REMORA.fig.nn.nn_train_test_set.headText = uicontrol(REMORA.fig.nn.nn_train_test_set.figH, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'String',labelStr, ...
    'FontSize',12,...
    'FontUnits','normalized', ...
    'FontWeight','bold',...
    'Visible','on');  %'BackgroundColor',bgColor3,...

btnPos=[0 .8 1 .1];
REMORA.fig.nn.nn_train_test_set.backgrnd = uicontrol(REMORA.fig.nn.nn_train_test_set.figH, ...
    'Style','text', ...
    'Units','normalized', ...
    'HorizontalAlignment','Left',...
    'Position',btnPos, ...
    'BackgroundColor',[.68,.92,.1],...
    'FontSize',11,...
    'FontUnits','normalized', ...
    'FontWeight','bold',...
    'Visible','on');  

labelStr = '  Data Type: ';
btnPos=[0.03 .8 .4 .08];
REMORA.fig.nn.nn_train_test_set.dataTypeTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH, ...
    'Style','text', ...
    'Units','normalized', ...
    'HorizontalAlignment','Left',...
    'Position',btnPos, ...
    'BackgroundColor',[.68,.92,.1],...
    'String',labelStr, ...
    'FontSize',11,...
    'FontUnits','normalized', ...
    'FontWeight','bold',...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.dataType),...
    'Visible','on');  

%% Bin Level Text
labelStr = 'Bin Level';
btnPos=[.3 .8 .25 .1];
REMORA.fig.nn.nn_train_test_set.binCheckTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'BackgroundColor',[.68,.92,.1],...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontWeight','bold',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Value', REMORA.nn.train_test_set.binTF,...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setBinLevel'});

%% Click Level Text
labelStr = 'Detection Level';
btnPos=[.6 .8 .25 .1];
REMORA.fig.nn.nn_train_test_set.clickCheckTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'BackgroundColor',[.68,.92,.1],...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontWeight','bold',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Value', REMORA.nn.train_test_set.clickTF,...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setClickLevel'});

%% Input Folder Text
labelStr = 'Input Base Folder';
btnPos=[.02 .67 .25 .1];
REMORA.fig.nn.nn_train_test_set.inDirTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.baseDir),...
    'Visible','on');

btnPos=[.3 .7 .6 .08];
REMORA.fig.nn.nn_train_test_set.inDirEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','left',...
    'String',REMORA.nn.train_test_set.inDir,...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setInDir'});

%% Input Bin File Ending Text
labelStr = 'Bin File Wildcard';
btnPos=[.02 .58 .25 .1];
REMORA.fig.nn.nn_train_test_set.binWildTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.binWild),...
    'Visible','on');

btnPos=[.3 .61 .2 .08];
REMORA.fig.nn.nn_train_test_set.binWildEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','left',...
    'String',REMORA.nn.train_test_set.binWild,...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setBinWild'});

%% Input Det File Ending Text
labelStr = 'Detection File Wildcard';
btnPos=[.51 .58 .2 .1];
REMORA.fig.nn.nn_train_test_set.detWildTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Left',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.detWild),...
    'Visible','on');

btnPos=[.7 .61 .2 .08];
REMORA.fig.nn.nn_train_test_set.detWildEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','left',...
    'String',REMORA.nn.train_test_set.detWild,...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setDetWild'});

%% Output Folder Text
labelStr = 'Output Folder';
btnPos=[.02 .49 .25 .1];
REMORA.fig.nn.nn_train_test_set.saveDirTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.outDir),...
    'Visible','on');

btnPos=[.3 .52 .6 .08];
REMORA.fig.nn.nn_train_test_set.saveDirEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','left',...
    'String',REMORA.nn.train_test_set.outDir,...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setSaveDir'});

%% Output File Name Text
labelStr = 'Output File Name';
btnPos=[.02 .40 .25 .1];
REMORA.fig.nn.nn_train_test_set.saveNameTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.saveName),...
    'Visible','on');

btnPos=[.3 .43 .3 .08];
REMORA.fig.nn.nn_train_test_set.saveNameEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','left',...
    'String',REMORA.nn.train_test_set.saveName,...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setSaveName'});

%% Training Percentage Text
labelStr = '%% of Dataset for Training';
btnPos=[.02 .31 .25 .1];
REMORA.fig.nn.nn_train_test_set.trainPercTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.trainPerc),...
    'Visible','on');

btnPos = [.3 .34 .1 .08];
REMORA.fig.nn.nn_train_test_set.trainPercEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','center',...
    'string',num2str(REMORA.nn.train_test_set.trainPerc),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setTrainPerc'});

%% Number of training examples 
labelStr = 'Max Training Set Size';
btnPos=[.5 .31 .20 .1];
REMORA.fig.nn.nn_train_test_set.trainSizeTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Left',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.trainSize),...
    'Visible','on');

btnPos = [.7 .34 .1 .08];
REMORA.fig.nn.nn_train_test_set.trainSizeEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','center',...
    'string',num2str(REMORA.nn.train_test_set.trainSize),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setTrainSize'});

%% Bout Gap 
labelStr = 'Bout Gap (minutes)';
btnPos=[.02 .23 .25 .1];
REMORA.fig.nn.nn_train_test_set.boutGapTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','Right',...
    'String',sprintf(labelStr,'Interpreter','tex'),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'TooltipString',sprintf(REMORA.nn.nn_ui_help.boutGap),...
    'Visible','on');

btnPos = [.3 .25 .1 .08];
REMORA.fig.nn.nn_train_test_set.boutGapEdTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor','white',...
    'HorizontalAlignment','center',...
    'string',num2str(REMORA.nn.train_test_set.boutGap),...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setBoutGap'});

%% train on what?
btnPos = [.1 .17 .2 .08];
REMORA.fig.nn.nn_train_test_set.trainOnTxt = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','text',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','center',...
    'string','Train on:',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Visible','on');

% use spectra
if ~isfield(REMORA.nn.train_test_set,'useSpectra')
    REMORA.nn.train_test_set.useSpectra = 1;
end
btnPos = [.3 .16 .2 .08];
REMORA.fig.nn.nn_train_test_set.useSpectraCheck = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','center',...
    'string','Spectra',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Value', REMORA.nn.train_test_set.useSpectra,...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setUseSpectra'});

% use wave
if ~isfield(REMORA.nn.train_test_set,'useWave')
    REMORA.nn.train_test_set.useWave = 0;
end
btnPos = [.5 .16 .2 .08];
REMORA.fig.nn.nn_train_test_set.useWaveCheck = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','center',...
    'string','Waveform',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Value', REMORA.nn.train_test_set.useWave,...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setUseWave'});

% use ici
if ~isfield(REMORA.nn.train_test_set,'useICI')
    REMORA.nn.train_test_set.useICI = 0;
end
btnPos = [.7 .16 .2 .08];
REMORA.fig.nn.nn_train_test_set.useICICheck = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',btnPos,...
    'HorizontalAlignment','center',...
    'string','ICI',...
    'FontSize',10,...
    'FontUnits','normalized', ...
    'Value', REMORA.nn.train_test_set.useICI,...
    'Visible','on',...
    'Callback',{@nn_ui_train_test_set_control,'setUseICI'});

REMORA.fig.nn.nn_train_test_set.runButton = uicontrol(REMORA.fig.nn.nn_train_test_set.figH,...
    'Style','pushbutton',...
    'String','Run',...
    'Units','normalized',...
    'Position',[.3 .02 .4 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',{@nn_ui_train_test_set_control,'Run'});

function nn_ui_init_train_test_set
global REMORA
REMORA.nn.train_test_set.binTF = 1;
REMORA.nn.train_test_set.clickTF = 0;
REMORA.nn.train_test_set.inDir = '';
REMORA.nn.train_test_set.outDir = '';
REMORA.nn.train_test_set.saveName = '';
REMORA.nn.train_test_set.trainPerc = 66;
REMORA.nn.train_test_set.trainSize = 1000;
REMORA.nn.train_test_set.boutGap = 15;
REMORA.nn.train_test_set.binWild = '*binLevel.mat';
REMORA.nn.train_test_set.detWild = '*detLevel.mat';