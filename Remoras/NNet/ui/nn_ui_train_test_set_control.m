function nn_ui_train_test_set_control(hObject,eventdata,myEvent)

global REMORA

if strcmp(myEvent, 'setBinLevel')
    REMORA.nn.train_test_set.binTF = ...
        get(REMORA.fig.nn.nn_train_test_set.binCheckTxt,'Value');
    
elseif strcmp(myEvent, 'setClickLevel')
    REMORA.nn.train_test_set.clickTF = ...
        get(REMORA.fig.nn.nn_train_test_set.clickCheckTxt,'Value');
    
elseif strcmp(myEvent, 'setInDir')
    REMORA.nn.train_test_set.inDir = ...
        get(REMORA.fig.nn.nn_train_test_set.inDirEdTxt,'String');
    
elseif strcmp(myEvent, 'setSaveDir')
    REMORA.nn.train_test_set.outDir = ...
        get(REMORA.fig.nn.nn_train_test_set.saveDirEdTxt,'String');
    
elseif strcmp(myEvent, 'setSaveName')
    REMORA.nn.train_test_set.saveName = ...
        get(REMORA.fig.nn.nn_train_test_set.saveNameEdTxt,'String');
    
elseif strcmp(myEvent, 'setTrainPerc')
    REMORA.nn.train_test_set.trainPerc = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set.trainPercEdTxt,'String'));
    
    if REMORA.fig.nn.nn_train_test_set.trainPerc>1
        % make it a fraction if needed.
        REMORA.fig.nn.nn_train_test_set.trainPerc = ...
            REMORA.fig.nn.nn_train_test_set.trainPerc/100;
    end
elseif strcmp(myEvent, 'setTrainSize')
    REMORA.nn.train_test_set.trainSize = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set.trainSizeEdTxt,'String'));
    
elseif strcmp(myEvent, 'setBoutGap')
    REMORA.nn.train_test_set.boutGap = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set.boutGapEdTxt,'String'));
    
elseif strcmp(myEvent, 'Run')
    if REMORA.nn.train_test_set.binTF
        REMORA.nn.train_train_set.savedTrainFile_bin = [];
        REMORA.nn.train_test_set.savedTrainFile_bin = [];
        
        [REMORA.nn.train_test_set.savedTrainFile_bin,...
            REMORA.nn.train_test_set.savedTestFile_bin] = nn_fn_balanced_input_bin(...
            REMORA.nn.train_test_set.inDir,...
            REMORA.nn.train_test_set.outDir,...
            REMORA.nn.train_test_set.saveName,...
            REMORA.nn.train_test_set.trainPerc,...
            REMORA.nn.train_test_set.trainSize,...
            REMORA.nn.train_test_set.boutGap);
        fprintf('Bin-level training and test sets saved to: \n')
        fprintf('% s\n',REMORA.nn.train_test_set.outDir)
    end
    
    if REMORA.nn.train_test_set.clickTF
        REMORA.nn.train_train_set.savedTrainFile_det = [];
        REMORA.nn.train_test_set.savedTrainFile_det = [];
        
        [REMORA.nn.train_test_set.savedTrainFile_det,...
            REMORA.nn.train_test_set.savedTestFile_det] = nn_fn_balanced_input(...
            REMORA.nn.train_test_set.inDir,...
            REMORA.nn.train_test_set.outDir,...
            REMORA.nn.train_test_set.saveName,...
            REMORA.nn.train_test_set.trainPerc,...
            REMORA.nn.train_test_set.trainSize,...
            REMORA.nn.train_test_set.boutGap);
        fprintf('Detection-level training and test sets saved to: \n')
        fprintf('% s\n',REMORA.nn.train_test_set.outDir);
    end
    close(REMORA.fig.nn.nn_train_test_set.figH)
    
elseif strcmp(myEvent, 'setInDirTPWS')
      REMORA.nn.nn_train_test_set_TPWS.inDir = ...
        get(REMORA.fig.nn.nn_train_test_set_TPWS.inDirEdTxt,'String');
elseif strcmp(myEvent, 'setSaveDirTPWS')
      REMORA.nn.nn_train_test_set_TPWS.saveDir = ...
        get(REMORA.fig.nn.nn_train_test_set_TPWS.saveDirEdTxt,'String');
elseif strcmp(myEvent, 'setSaveNameTPWS')
      REMORA.nn.nn_train_test_set_TPWS.saveName = ...
        get(REMORA.fig.nn.nn_train_test_set_TPWS.saveNameEdTxt,'String');
elseif strcmp(myEvent, 'setTrainPercTPWS')
    REMORA.nn.nn_train_test_set_TPWS.trainPerc = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set_TPWS.trainPercEdTxt,'String'));
    
    if REMORA.fig.nn.nn_train_test_set_TPWS.trainPerc>1
        % make it a fraction if needed.
        REMORA.fig.nn.nn_train_test_set_TPWS.trainPerc = ...
            REMORA.fig.nn.nn_train_test_set_TPWS.trainPerc/100;
    end
    
elseif strcmp(myEvent, 'setTrainSizeTPWS')
    REMORA.nn.nn_train_test_set_TPWS.trainSize = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set_TPWS.trainSizeEdTxt,'String'));
    
elseif strcmp(myEvent, 'setBoutGapTPWS')
    REMORA.nn.nn_train_test_set_TPWS.boutGap = ...
        str2num(get(REMORA.fig.nn.nn_train_test_set_TPWS.boutGapEdTxt,'String'));
    
    
elseif strcmp(myEvent, 'RunTPWS')
    nn_fn_balanced_input_TPWS
else
    error('Unrecognized callback')
end

