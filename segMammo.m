function varargout = segMammo(varargin)
% USER INTERFACE CODE
% segMammo MATLAB code for segMammo.fig
%      segMammo, by itself, creates a new segMammo or raises the existing
%      singleton*.
%
%      H = segMammo returns the handle to a new segMammo or the handle to
%      the existing singleton*.
%
%      segMammo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in segMammo.M with the given input arguments.
%
%      segMammo('Property','Value',...) creates a new segMammo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segMammo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segMammo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segMammo

% Last Modified by GUIDE v2.5 30-Jul-2019 17:37:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segMammo_OpeningFcn, ...
                   'gui_OutputFcn',  @segMammo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before segMammo is made visible.
function segMammo_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for segMammo
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%Load LOGO
I = imread('logoETSE.png');
axes(handles.axesLogo);
imshow(I);
% Clear workspace, remove old images in folder
myDir = fullfile(pwd, '.\expected');
dinfo = dir(myDir);
dinfo([dinfo.isdir]) = [];   %skip directories
filenames = fullfile(myDir, {dinfo.name});
if ~isempty(filenames)
    delete( filenames{:} )
end

% --- Outputs from this function are returned to the command line.
function varargout = segMammo_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% ----------------------------- LOAD IMAGE ----------------------------- %

% --- Executes during object creation, after setting all properties.
function editLoad_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Browse the path of the image to process
function btnBrowse_Callback(hObject, eventdata, handles)
[Filename, Pathname] = uigetfile('*.*', 'Image Selector');
name = strcat(Pathname,Filename);
set(handles.editLoad, 'string', name);

% --- Load the image in the program
function btnLoad_Callback(hObject, eventdata, handles)
% Disable buttons and results
hideButtons(handles);
% Load image
name = get(handles.editLoad, 'string');
if exist(name, 'file')
    [filepath,~,ext] = fileparts(name); % Obtain and check file extension
    if strcmp(ext,'.jpg') || strcmp(ext,'.png')
        set(handles.txtLoadSuccess, 'String', '');
        % Show image in panel
        drawImage(handles.txtNoImage, name, handles.axesLoaded)
        %Clear workspace
        myDir = fullfile(pwd, '.\expected');
        dinfo = dir(myDir);
        dinfo([dinfo.isdir]) = [];   %skip directories
        filenames = fullfile(myDir, {dinfo.name});
        if ~isempty(filenames) && ~strcmp(filepath,myDir)
            delete( filenames{:} )
        end
        % Store image in workspace
        if ~strcmp(filepath,myDir)
            copyfile(name, myDir);
        end
        % Enable RUN button
        set(handles.btnRun, 'Enable', 'On');
    else
        % When file is not .png or .jpg
        set(handles.txtLoadSuccess, 'String', 'Wrong File Extension');
    end
else
    % When file is not found
    set(handles.txtLoadSuccess, 'String', 'File Not Found');
end


% ----------------------------- SETTINGS -------------------------------- %

% --- Executes during popupmenu creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu. Choose the optimisation
% function in GWO
function popupmenu_Callback(hObject, eventdata, handles)
v = get(handles.popupmenu, 'Value');
global opt;
switch v
    case 1
        opt = '';
    case 2
        opt = 'F1';
    case 3
        opt = 'F2';
    case 4
        opt = 'F3';
end
set(handles.btnRun, 'Enable', 'On');

% --- Executes during object creation, after setting all properties.
function editIterations_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------------------------- RUN PROGRAM ----------------------------- %

% --- Runs the main algorythm and processes the image
function btnRun_Callback(hObject, eventdata, handles)
global opt ite;
strIte = get(handles.editIterations, 'String');
ite = str2double(strIte);
if all(ismember(strIte, '1234567890'))
    % handle number of iterations
    set(handles.txtIteError, 'Visible', 'Off');
    if ~strcmp(opt,'') && strcmp(strIte,'')
        ite = 10;
    end
    hideButtons(handles);
    set(handles.btnRun, 'Enable', 'Off'); drawnow;
    % Run the Code
    addpath(genpath('./functions'),'-end');
    [brsArea, pecArea, dnsArea, needFlip, isMLO] = exe(opt);
    % Set Results
        % View
    if isMLO
        set(handles.rTxtView, 'String', 'MLO');
    else
        set(handles.rTxtView, 'String', 'CC');
    end
        % Orientation
    if needFlip
        set(handles.rTxtOrient, 'String', 'Right');
    else
        set(handles.rTxtOrient, 'String', 'Left');
    end
        % Density and BIRADS level
    dy = dnsArea/(brsArea-pecArea)*100;
    dy = round( dy, 3);
    dys = num2str(dy);
    set(handles.rTxtDensity, 'String', strcat(dys,' %'));
    switch 1
        case dy<=25
            set(handles.rTxtBIRADS, 'String', ' I');
        case dy>25 && dy<=50
            set(handles.rTxtBIRADS, 'String', 'II');
        case dy>50 && dy<=75
            set(handles.rTxtBIRADS, 'String', 'III');
        case dy>50
            set(handles.rTxtBIRADS, 'String', 'IV');
    end
    % Enable Display Buttons
    set(handles.btnSegBreast, 'Enable', 'On');
    set(handles.btnDense, 'Enable', 'On');
    if isMLO
        set(handles.btnPoints, 'Enable', 'On');
        set(handles.btnSegPectoral, 'Enable', 'On');
        set(handles.txtDisabled, 'Visible', 'Off');
    else
        set(handles.btnPoints, 'Enable', 'Off');
        set(handles.btnSegPectoral, 'Enable', 'Off');
        set(handles.txtDisabled, 'Visible', 'On');
    end
    set(handles.btnRun, 'Enable', 'On');
else
    set(handles.editIterations, 'String', '');
    set(handles.txtIteError, 'Visible', 'On');
end

% --------------------------- DISPLAY OPTIONS --------------------------- %

% --- Displays the segmented Breast Region from the Image
function btnSegBreast_Callback(hObject, eventdata, handles)
loadImage(handles, '.\result\1segBreast\');

% --- Displays the Points of Interest before the Pectoral segmentation
function btnPoints_Callback(hObject, eventdata, handles)
loadImage(handles, '.\result\3geometries\');

% --- Executes on button press in btnSegPectoral.
function btnSegPectoral_Callback(hObject, eventdata, handles)
loadImage(handles, '.\result\4segPectoral\');

% --- Displays the segmented Dense Region from the Image
function btnDense_Callback(hObject, eventdata, handles)
loadImage(handles, '.\result\5segDense\');


% ------------------------------ FUNCTIONS ------------------------------ %

% --- Subfunction used on each button to load and show the image of its
% corresponding folder
function loadImage (handles, myDir)
% Find the image
jpgs = dir(fullfile(myDir,'*.jpg')); %gets jpg files in dir
pngs = dir(fullfile(myDir,'*.png')); %gets png files in dir
myFiles = cat(1,jpgs,pngs);
% Load the 1st image found (should only be a vector of 1 element)
if ~isempty(myFiles)
    baseFileName = myFiles(1).name;
    fullFileName = fullfile(myDir, baseFileName);
    % Draw the image in axes
    drawImage(handles.txtNoDisplay, fullFileName, handles.axesDisplay)
else
    % In case of error, unexisting image
    cla(handles.axesDisplay)
    set(handles.txtNoDisplay, 'Visible', 'on');
    set(handles.txtNoDisplay, 'String', 'Display unavailable');
end

% --- Subfunction that hides/disables all the Results and display Options
function hideButtons(handles)
set(handles.btnSegBreast, 'Enable', 'Off');
set(handles.btnDense, 'Enable', 'Off');
set(handles.btnPoints, 'Enable', 'Off');
set(handles.btnSegPectoral, 'Enable', 'Off');
set(handles.rTxtView, 'String', '');
set(handles.rTxtOrient, 'String', '');
set(handles.rTxtDensity, 'String', '');
set(handles.rTxtBIRADS, 'String', '');
cla(handles.axesDisplay);
set(handles.txtNoDisplay, 'Visible', 'On');
set(handles.txtNoDisplay, 'String', 'No Display option seleted yet...');

% --- Subfunction that shows a selected image to a given axes
function drawImage(txt, imgName, axs)
set(txt, 'Visible', 'off');
I = imread(imgName);
axes(axs);
imshow(I);
