  
function varargout = Posiciondeseada(varargin)
% POSICIONDESEADA MATLAB code for Posiciondeseada.fig
%      POSICIONDESEADA, by itself, creates a new POSICIONDESEADA or raises the existing
%      singleton*.
%
%      H = POSICIONDESEADA returns the handle to a new POSICIONDESEADA or the handle to
%      the existing singleton*.
%
%      POSICIONDESEADA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSICIONDESEADA.M with the given input arguments.
%
%      POSICIONDESEADA('Property','Value',...) creates a new POSICIONDESEADA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Posiciondeseada_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Posiciondeseada_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Posiciondeseada

% Last Modified by GUIDE v2.5 09-Nov-2017 15:00:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Posiciondeseada_OpeningFcn, ...
                   'gui_OutputFcn',  @Posiciondeseada_OutputFcn, ...
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


% --- Executes just before Posiciondeseada is made visible.
function Posiciondeseada_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Posiciondeseada (see VARARGIN)

% Choose default command line output for Posiciondeseada
set(handles.Pxa,'String',num2str(250));
set(handles.Pya,'String',num2str(0));
set(handles.Pxd,'String','0');
set(handles.Pyd,'String','0');

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

function varargout = Posiciondeseada_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc
global puerto_serial
global toolDesact
global toolAct


if (get(handles.radiobutton1,'Value') == 0)
    ang = toolDesact;
else
    ang = toolAct;
end

L1 = 110;
L2 = 140;
Pxd = 0;
Pyd = L1 + L2;
Pxa = str2double(get(handles.Pxa,'String'));
Pya = str2double(get(handles.Pya,'String'));
[q1,q2] = Scara_Inversa(Pxd,Pyd,L1,L2);
[q1a,q2a] = Scara_Inversa(Pxa,Pya,L1,L2);

if (Pxd==Pxa && Pyd==Pya)
    disp('Ya esta en el lugar deseado1')
    set(handles.q1del,'String',num2str(0));
    set(handles.q2del,'String',num2str(0));
else
    q1delta=(q1a-q1);
    q2delta=(q2a-q2);
    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));
    set(handles.q1del,'String',num2str(q1delta));
    set(handles.q2del,'String',num2str(q2delta));
    
    A=q1*(96/1.8);
    B=q2*(32/1.8);
    
    fprintf('$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,ang]);
    fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,ang]);
    
end


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global puerto_serial
global toolDesact
global toolAct
L1=110;
L2=140;
Pxd=str2double(get(handles.Pxd,'String'));
Pyd=str2double(get(handles.Pyd,'String'));
Pxa=str2double(get(handles.Pxa,'String'));
Pya=str2double(get(handles.Pya,'String'));

[q1,q2]=Scara_Inversa(Pxd,Pyd,L1,L2);     %%%%radioButton codo arriba
[q1a,q2a]=Scara_Inversa(Pxa,Pya,L1,L2);

if (get(handles.radiobutton1,'Value') == 0)
    ang = toolDesact;
else
    ang = toolAct;
end

set(handles.q1a,'String',num2str(q1a));
set(handles.q2a,'String',num2str(q2a));

if (Pxd==Pxa && Pyd==Pya)
    disp('Ya esta en el lugar deseado2')
    set(handles.q1del,'String',num2str(0));
    set(handles.q2del,'String',num2str(0));
elseif (q1<-90|| q1>90)
    disp('Fuera del espacio de trabajo1')
elseif (q2<-60 || q2>150)
    disp('Fuera del espacio de trabajo2')
elseif ((strcmp('Nulo',q1)) || ((strcmp('Nulo',q2))))
    disp('Posicion fuera del espacio de trabajo3');
else
    q1delta=(q1a-q1);
    q2delta=(q2a-q2);
    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));  
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));
    set(handles.q1del,'String',num2str(q1delta));
    set(handles.q2del,'String',num2str(q2delta));
    
    A=q1*(96/1.8);
    B=q2*(32/1.8);
    
    fprintf('$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,ang]);
    fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,ang]);
      
end

function Pxd_Callback(hObject, eventdata, handles)

function Pxd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pyd_Callback(hObject, eventdata, handles)

function Pyd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pxa_Callback(hObject, eventdata, handles)

function Pxa_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pya_Callback(hObject, eventdata, handles)

function Pya_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q1f_Callback(hObject, eventdata, handles)

function q1f_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q2f_Callback(hObject, eventdata, handles)

function q2f_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q1a_Callback(hObject, eventdata, handles)

function q1a_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q2a_Callback(hObject, eventdata, handles)

function q2a_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q1del_Callback(hObject, eventdata, handles)

function q1del_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q2del_Callback(hObject, eventdata, handles)

function q2del_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton3_Callback(hObject, eventdata, handles)

global puerto_serial
global toolAct
global toolDesact
global L
delete(instrfind({'port'},{'COM8'}));
puerto_serial=serial('COM8');
puerto_serial.BaudRate=115200;
warning('off','Matlab:serial:fscanf:unsuccessfulRead');
fopen(puerto_serial);

L=10;
toolAct = 73;
toolDesact = 60;


function CerrarARD_Callback(hObject, eventdata, handles)
global puerto_serial
global toolDesact
fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[4800,0,toolDesact]);
pause(1);
delete(puerto_serial);
clc;
clear;

function radiobutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in LaM.
function LaM_Callback(hObject, eventdata, handles)
    global puerto_serial
    global toolAct
    global toolDesact
    global L
    
    scale = str2double(get(handles.escala,'String'))/5;
    
    L1=110;
    L2=140;
    %M1
    Pxa=str2double(get(handles.Pxa,'String'));
    Pya=str2double(get(handles.Pya,'String'));

%     coordsM = [0  0  0  0  0  0  0  0  0;
%                10 20 30 40 50 60 70 80 0];
%     coordsM = [0  0  0  0  0  0  0  0  0  5  10 15 20 25 30 35 40 45 50 50 50 50 50 50 50 50 50 50 50 0;
%                10 15 20 25 30 35 40 45 50 45 40 35 30 25 30 35 40 45 50 45 40 35 30 25 20 15 10  5  0 0];

    
    coordsM = [-10 0*ones(1,L)       -10  linspace(0,25,L)     linspace(25,50,L) 60  50*ones(1,L)        60   0;
               0   linspace(0,50,L)   50  linspace(50,25,L)    linspace(25,50,L) 50  linspace(50,0,L)    0    0;
               toolAct*ones(1,L+2)    toolAct*ones(1,L)        toolAct*ones(1,L+1)   toolAct*ones(1,L+1) toolDesact];
           
    coordsM(1,:) = scale * coordsM(1,:) + Pxa;
    coordsM(2,:) = scale * coordsM(2,:) + Pya;
    
    for i=1:length(coordsM(2,:))
        [q1,q2]=Scara_Inversa(coordsM(1,i),coordsM(2,i),L1,L2);
        A=q1*(96/1.8);
        B=q2*(32/1.8);
        fprintf('$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B]);
        flushinput(puerto_serial);
        fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B ,coordsM(3,i)]);
        pause(0.5)
%         while(fscanf(puerto_serial) == '')
%             pause(0.01)
%         end

    end
    Pxd = coordsM(1,end);
    Pyd = coordsM(2,end);

    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));

    



% hObject    handle to LaM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%     coordsY = [0  0  0  0  0  0  0  0  0;
%                10 20 30 40 50 60 70 80 0];
%     scale = 10;
%     coordsY = [25 25  25  25  25  25  20  15  10  5    0   5  10  15  20 25 30  35  40  45  50  0;
%                0  5   10  15  20  25  30  35  40  45  50  45  40  35  30 25 30  35  40  45  50  0];
%     L=20;
%     coordsY = [25*ones(1,L)     linspace(25,0,L)  linspace(0,25,L)  linspace(25,50,L) 0;
%                linspace(0,25,L) linspace(25,50,L) linspace(50,25,L) linspace(25,50,L) 0];

% --- Executes on button press in LaY.
function LaY_Callback(hObject, eventdata, handles)
    global puerto_serial
    global toolAct
    global toolDesact
    global L
    
    scale = str2double(get(handles.escala,'String'))/5;
    
    L1=110;
    L2=140;
    %M1
    Pxa=str2double(get(handles.Pxa,'String'));
    Pya=str2double(get(handles.Pya,'String'));

%     coordsY = [0  0  0  0  0  0  0  0  0;
%                10 20 30 40 50 60 70 80 0];
%     coordsY = [25 25  25  25  25  25  20  15  10  5    0   5  10  15  20 25 30  35  40  45  50  0;
%                0  5   10  15  20  25  30  35  40  45  50  45  40  35  30 25 30  35  40  45  50  0];
    
    L=10;
    coordsY = [15 35 25*ones(1,L)              linspace(25,0,L)  -10 10  linspace(0,25,2)  linspace(25,50,L)  60  40 0;
               0  0  linspace(0,25,L)          linspace(25,50,L)  50 50 linspace(50,25,2) linspace(25,50,L)   50  50 0;
               toolDesact toolAct*ones(1,L+1)  toolAct*ones(1,L+2) toolDesact*ones(1,2)   toolAct*ones(1,L+2) toolDesact];
           
    coordsY(1,:) = scale * coordsY(1,:) + Pxa;
    coordsY(2,:) = scale * coordsY(2,:) + Pya;
    
    for i=1:length(coordsY(2,:))
        [q1,q2]=Scara_Inversa(coordsY(1,i),coordsY(2,i),L1,L2);
        A=q1*(96/1.8);
        B=q2*(32/1.8);
        fprintf('$;A=%10.0f;B=%10.0f;*\n',[A,B]);
        flushinput(puerto_serial);
        fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,coordsY(3,i)]);
        pause(0.5);
%         while(fgets(puerto_serial) == '')
%             pause(0.01)
%         end
    end
    Pxd = coordsY(1,end);
    Pyd = coordsY(2,end);

    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));



function escala_Callback(hObject, eventdata, handles)
% hObject    handle to escala (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escala as text
%        str2double(get(hObject,'String')) returns contents of escala as a double


% --- Executes during object creation, after setting all properties.
function escala_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escala (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Circulo.
function Circulo_Callback(hObject, eventdata, handles)
% hObject    handle to Circulo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global puerto_serial
    global toolAct
    global toolDesact
    global L
    
    scale = str2double(get(handles.escala,'String'));
    
    L1=110;
    L2=140;
    %M1
    Pxa=str2double(get(handles.Pxa,'String'));
    Pya=str2double(get(handles.Pya,'String'));

%     coordsY = [0  0  0  0  0  0  0  0  0;
%                10 20 30 40 50 60 70 80 0];
%     coordsY = [25 25  25  25  25  25  20  15  10  5    0   5  10  15  20 25 30  35  40  45  50  0;
%                0  5   10  15  20  25  30  35  40  45  50  45  40  35  30 25 30  35  40  45  50  0];
    
    L=35;
    
    theta = linspace(0,2*pi,L);
    rho = scale*ones(size(theta));
    
    [x,y] = pol2cart(theta,rho);
    
    coordsY = [x 0;
               y 0;
               toolDesact toolAct*ones(1,length(x)-1) toolDesact];
           
    coordsY(1,:) = scale * coordsY(1,:) + Pxa;
    coordsY(2,:) = scale * coordsY(2,:) + Pya;
    
    for i=1:length(coordsY(2,:))
        [q1,q2]=Scara_Inversa(coordsY(1,i),coordsY(2,i),L1,L2);
        A=q1*(96/1.8);
        B=q2*(32/1.8);
        fprintf('$;A=%10.0f;B=%10.0f;*\n',[A,B]);
        flushinput(puerto_serial);
        fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,coordsY(3,i)]);
        pause(0.5);
%         while(fgets(puerto_serial) == '')
%             pause(0.01)
%         end
    end
    Pxd = coordsY(1,end);
    Pyd = coordsY(2,end);

    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));


% --- Executes on button press in dick.
function dick_Callback(hObject, eventdata, handles)
% hObject    handle to Circulo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global puerto_serial
    global toolAct
    global toolDesact
    
    scale = str2double(get(handles.escala,'String'));
    
    L1=110;
    L2=140;
    %M1
    Pxa=str2double(get(handles.Pxa,'String'));
    Pya=str2double(get(handles.Pya,'String'));

%     coordsY = [0  0  0  0  0  0  0  0  0;
%                10 20 30 40 50 60 70 80 0];
%     coordsY = [25 25  25  25  25  25  20  15  10  5    0   5  10  15  20 25 30  35  40  45  50  0;
%                0  5   10  15  20  25  30  35  40  45  50  45  40  35  30 25 30  35  40  45  50  0];
    
    L=10;
    
    theta = linspace(0,2*pi,L);
%     rho = scale*ones(size(theta));
    rhoGva = 13*ones(size(theta));
    
%     [x,y] = pol2cart(theta,rho);
    [xGva,yGva] = pol2cart(theta,rhoGva);
    
    
    
    coordsY = [xGva+Pxa     xGva+Pxa      linspace(Pxa+13,Pxa+75,10) xGva+Pxa+75  linspace(Pxa+75,Pxa+13,10)  Pxa;
               yGva+Pya     yGva+Pya+25   (Pya+25)*ones(1,10)     yGva+Pya+15  (Pya)*ones(1,10)         Pya;
               toolDesact   toolAct*ones(1,(3*L + 20)-1)                     toolDesact];
           
%     coordsY(1,:) = scale * coordsY(1,:) + Pxa;
%     coordsY(2,:) = scale * coordsY(2,:) + Pya;
    
    for i=1:length(coordsY(2,:))
        [q1,q2]=Scara_Inversa(coordsY(1,i),coordsY(2,i),L1,L2);
        A=q1*(96/1.8);
        B=q2*(32/1.8);
        fprintf('$;A=%10.0f;B=%10.0f;*\n',[A,B]);
        flushinput(puerto_serial);
        fprintf(puerto_serial,'$;A=%10.0f;B=%10.0f;T=%10.0f;*\n',[A,B,coordsY(3,i)]);
        pause(0.5);
%         while(fgets(puerto_serial) == '')
%             pause(0.01)
%         end
    end
    Pxd = coordsY(1,end);
    Pyd = coordsY(2,end);

    set(handles.Pxa,'String',num2str(Pxd));
    set(handles.Pya,'String',num2str(Pyd));
    set(handles.q1f,'String',num2str(q1));
    set(handles.q2f,'String',num2str(q2));



function NPoints_Callback(hObject, eventdata, handles)
% hObject    handle to NPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NPoints as text
%        str2double(get(hObject,'String')) returns contents of NPoints as a double


% --- Executes during object creation, after setting all properties.
function NPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
