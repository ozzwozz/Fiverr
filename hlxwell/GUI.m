
function varargout = GUI(varargin)
    %GUI MATLAB code file for GUI.fig
    %      GUI, by itself, creates a new GUI or raises the existing
    %      singleton*.
    %
    %      H = GUI returns the handle to a new GUI or the handle to
    %      the existing singleton*.
    %
    %      GUI('Property','Value',...) creates a new GUI using the
    %      given property value pairs. Unrecognized properties are passed via
    %      varargin to GUI_OpeningFcn.  This calling syntax produces a
    %      warning when there is an existing singleton*.
    %
    %      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
    %      local function named CALLBACK in GUI.M with the given input
    %      arguments.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help GUI

    % Last Modified by GUIDE v2.5 22-Nov-2021 10:55:15

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_OutputFcn, ...
                       'gui_LayoutFcn',  [], ...
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
end

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   unrecognized PropertyName/PropertyValue pairs from the
    %            command line (see VARARGIN)

    % Choose default command line output for GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);    
end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in ForwardButton.
function ForwardButton_Callback(hObject, eventdata, handles)
% hObject    handle to ForwardButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sim;
global clientID;
disp('forward');
sim.simxAddStatusbarMessage(clientID,'forward!', sim.simx_opmode_oneshot);
forwardMove = [1, 1, 5];
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Movement', [forwardMove], 0, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes on button press in ReverseButton.
function ReverseButton_Callback(hObject, eventdata, handles)
% hObject    handle to ReverseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sim;
global clientID;
disp('reverse');
sim.simxAddStatusbarMessage(clientID,'reverse!', sim.simx_opmode_oneshot);
forwardMove = [-1, -1, 5];
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Movement', [forwardMove], 0, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes on button press in RightButton.
function RightButton_Callback(hObject, eventdata, handles)
% hObject    handle to RightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sim;
global clientID;
global TurningMove;

disp('right');
sim.simxAddStatusbarMessage(clientID,'right!', sim.simx_opmode_oneshot);
TurningMove = [-1, -1, 5];
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Turning', TurningMove, 0, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes on button press in LeftButton.
function LeftButton_Callback(hObject, eventdata, handles)
% hObject    handle to LeftButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sim;
global clientID;
global TurningMove;

disp('left');
sim.simxAddStatusbarMessage(clientID,'left!', sim.simx_opmode_oneshot);
TurningMove = [1, -1, 5];
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Turning', TurningMove, 0, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes on slider movement.
function Joint1_Callback(hObject, eventdata, handles)
% hObject    handle to Joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
global Joints;

Joints(1) = get(hObject,'Value');
sim.simxAddStatusbarMessage(clientID,[Joints], sim.simx_opmode_oneshot);
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Arm_Move_1', 0, Joints, 0, 0, sim.simx_opmode_streaming );
end

% --- Executes during object creation, after setting all properties.
function Joint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- Executes on slider movement.
function Joint2_Callback(hObject, eventdata, handles)
% hObject    handle to Joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
global Joints;

Joints(2) = get(hObject,'Value');

[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Arm_Move_2', 0, Joints, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes during object creation, after setting all properties.
function Joint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

end

% --- Executes on slider movement.
function Joint3_Callback(hObject, eventdata, handles)
% hObject    handle to Joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
global Joints;

Joints(3) = get(hObject,'Value');

[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Arm_Move_3', 0, Joints, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes during object creation, after setting all properties.
function Joint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on slider movement.
function Joint4_Callback(hObject, eventdata, handles)
% hObject    handle to Joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
global Joints;

Joints(4) = get(hObject,'Value');

[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Arm_Move_4', 0, Joints, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes during object creation, after setting all properties.
function Joint4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on slider movement.
function Speed_Callback(hObject, eventdata, handles)
% hObject    handle to Speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
Speed = get(hObject,'Value');
[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Speed_Change', Speed, 0, 0, 0, sim.simx_opmode_streaming );

end

% --- Executes during object creation, after setting all properties.
function Speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- Executes on slider movement.
function Joint5_Callback(hObject, eventdata, handles)
% hObject    handle to Joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sim;
global clientID;
global Joints;

Joints(5) = get(hObject,'Value');

[~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'youBot', sim.sim_scripttype_childscript, 'Arm_Move_5', 0, Joints, 0, 0, sim.simx_opmode_streaming );

end
% --- Executes during object creation, after setting all properties.
function Joint5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end
