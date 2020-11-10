%Racetrack with prescribed peristalsis and pericardium

L = 1;                              % length of computational domain (m)
N = 512;                            % number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = L/N;                           % Cartesian mesh width (m)
ds = L/(2*N);                       % space between boundary points in straight tube

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Lines 51-58 from generate mesh
% Parameters for the prescribed peristalsis
%Lap = 0.3;                          % length of the actuator section
% NLap = ceil(Lap/ds);                  % number of points along each actuator
%Cap = 0.5*Lt;                       % center of the actuator section
%NCap = ceil(ceil(Nstraight/2)*Cap/Lt); % index of the center point
%Na1p = NCap - ceil(NLap/2);            % index of the starting point with respect to the elastic section
%Na2p = Na1p+NLap-1;                    % index of the ending point with respect to the elastic section



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters for the racetrack

Let = 0.4;                          % Length of elastic tube (m)
Nend = 10;                           % Number of rigid points on each end of elastic section
Lt = Let+2*Nend*ds;                 % Length of straight section with three rigid points on each end

diameter = 0.1;                     % diameter of the tube
R2 = 0.1;                           % radius of inner wall
R1 = R2+diameter;                   % radius of outer wall
percent = 0.8;                      % percent contraction for applied force peristalsis

radius = .02;                       % Radius of obstacles 
gamma = 0 : asin(ds/radius) : 2*pi;  % used for making the circle obstacles

Nstraight = 2*ceil(Lt/ds);          % number of points along each straight section
Ncurve = 2*ceil(pi*R1/ds);          % number of points along each curved section
Nrace = Nstraight+2*Ncurve;         % number of points making up the racetrack part
Nracecirc = Nrace+5*length(gamma);  % number of points making up the circle obstacles
dtheta = pi/(Ncurve/2);             % angle increment for drawing curved edges

mesh_name = 'heart_';               % structure name



centery = 0;                        % y-position of center of curved sections
centerx1 = -0.5*Lt;                 % x-position of center of left curved section
centerx2 = 0.5*Lt;                  % x-position of center of right curved section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the pericardium
%Dp = 2*diameter;                    %diameter of the pericardium
%Nperi = 2*ceil((Dp-diameter)/ds);  % number of boundary points along the sides of the pericardium
%Nperitot = Nperi + Nstraight;       % total number of pericardium points

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the actuator
%La = 0.04;                          % length of the actuator section
%NLa = ceil(La/ds);                  % number of points along each actuator
%Ca = 0.25*Lt;                       % center of the actuator section
%NCa = ceil(ceil(Nstraight/2)*Ca/Lt); % index of the center point
%Na1 = NCa - ceil(NLa/2);            % index of the starting point with respect to the elastic section
%Na2 = Na1+NLa-1;                    % index of the ending point with respect to the elastic section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the prescribed peristalsis
Lap = 0.3;                            % length of the actuator section
NLap = ceil(Lap/ds);                  % number of points along each actuator
Cap = 0.5*Lt;                         % center of the actuator section
NCap = ceil(ceil(Nstraight/2)*Cap/Lt); % index of the center point
Na1p = NCap - ceil(NLap/2);            % index of the starting point with respect to the elastic section
Na2p = Na1p+NLap-1;                    % index of the ending point with respect to the elastic section


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for applied force peristalsis
%Lnperi = 0.05;                          % length of the end of the flexible tube without peristalsis
%Lperi = Lt-2*Lnperi;                      % length of the peristalsis section of tube
%Nperist = ceil(Lperi/ds);                 % number of peristaltic points on top or bottom of tube
%NCent = ceil(Nstraight/4);                 %index of center of elastic tube
%Nperi1 = NCent-ceil(0.5*Nperist);           % index of the starting point with respect to the elastic section
%Nperi2 = Nperi1+Nperist-1;                  %index of the ending point with respect to the elastic section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters for markers
Nmarkersx = 11;                     %number of columns of markers
Nmarkersy = 11;                     %number of markers in each column
Nmarkers=Nmarkersx*Nmarkersy;       %total number of markers
dmx = Let/(Nmarkersx-1);            %space between markers in x-direction
dmy = diameter/(Nmarkersy-1);       %space between markers in y-direction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% material parameters
kappa_spring = 30.0;               % spring constant (Newton)
kappa_beam = 0.3;                 % beam stiffness constant (Newton m^2) %2.5e-2 works for Wo>=5
kappa_target = kappa_spring;        % target point penalty spring constant (Newton)
Fmag = 4.0e0;                % this is my best guess at a reasonable applied force %4.0e0 works for Wo>=5
phase = 0;                      %initial phase of the oscillating force, where F=Fmag*phase and phase = (1+sin(2*pi*f*t-pi/2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make markers as vertices with no material properties

vertex_fid = fopen(['markers_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nmarkers);

%top part
for i=0:Nmarkersx-1
    for j=0:Nmarkersy-1
        y = centery-R2-j*dmy;
        x = -Let/2+i*dmx;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x, y);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prescribed peristalsis part
% Write out the vertex information

% Allocate space for variables
ytop_elastic = zeros(1,ceil(Nstraight/2));
xtop_elastic = zeros(1,ceil(Nstraight/2));
ybot_elastic = zeros(1,ceil(Nstraight/2));
xbot_elastic = zeros(1,ceil(Nstraight/2));

% Vertex information
vertex_fid = fopen([mesh_name 'tube_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nstraight);

% Top section, elastic tube
for i = 1:(Nstraight/2)
    ytop_elastic(1,i) = centery-R2;
    xtop_elastic(1,i) = -Lt/2+(i-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xtop_elastic(1,i), ytop_elastic(1,i));
end

% Bottom section, elastic tube
for  i = 1:(Nstraight/2)
    ybot_elastic(1,i) = centery-R1;
    xbot_elastic(1,i) = -Lt/2+(i-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xbot_elastic(1,i), ybot_elastic(1,i));
end

fclose(vertex_fid);

% Plots elastic tube vertices
plot(xtop_elastic,ytop_elastic,'r.')
hold on
plot(xbot_elastic,ybot_elastic,'g.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% race track part
% Write out the vertex information

% Allocate Space
x_race = zeros(1,Nrace);
y_race = zeros(1,Nrace);

vertex_fid = fopen([mesh_name 'race_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nracecirc);

%right inner curved part of racetrack 
for i=1:ceil(Ncurve/2)
    theta = (i-1)*dtheta-pi/2;
    y_race(1,i) = centery+R2*sin(theta);
    x_race(1,i) = Lt/2+R2*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end

%straight inner section on the top
for i = ceil(Ncurve/2)+1:ceil(Ncurve/2)+ceil(Nstraight/2)
    theta = (i-1)*dtheta-pi/2;
    theta1 = pi/2+(i-(ceil(Ncurve/2)+ceil(Nstraight/2))-1)*dtheta;
    y_race(1,i) = centery+R2-0.05*(-cos(theta))*cos(theta1);
    x_race(1,i) = centerx2-(i-ceil(Ncurve/2)-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end

%left inner curved part of racetrack
for i = ceil(Ncurve/2)+ceil(Nstraight/2)+1:Ncurve+ceil(Nstraight/2)
    theta = pi/2+(i-(ceil(Ncurve/2)+ceil(Nstraight/2))-1)*dtheta;
    y_race(1,i) = centery+R2*sin(theta);
    x_race(1,i) = centerx1+R2*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end

%right outer curved part of racetrack 
for i=Ncurve+ceil(Nstraight/2)+1:Ncurve+ceil(Ncurve/2)+ceil(Nstraight/2)
    theta=(i-(Ncurve+ceil(Nstraight/2))-1)*dtheta-pi/2;
    y_race(1,i) = centery+R1*sin(theta);
    x_race(1,i) = Lt/2+R1*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end

%straight outer section on the top
for i=Ncurve+ceil(Ncurve/2)+ceil(Nstraight/2)+1:Ncurve+ceil(Ncurve/2)+Nstraight
    theta=(i-(Ncurve+ceil(Nstraight/2))-1)*dtheta-pi/2;
    theta1=pi/2+(i-(Ncurve+ceil(Ncurve/2)+Nstraight)-1)*dtheta;
    y_race(1,i)=centery+R1+0.05*(-cos(theta))*cos(theta1);
    x_race(1,i)=centerx2-(i-(Ncurve+ceil(Ncurve/2)+ceil(Nstraight/2))-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end


%left outer curved part of racetrack
for i = Ncurve+ceil(Ncurve/2)+Nstraight+1:Nrace
    theta = pi/2+(i-(Ncurve+ceil(Ncurve/2)+Nstraight)-1)*dtheta;
    y_race(1,i) = centery+R1*sin(theta);
    x_race(1,i) = centerx1+R1*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', x_race(1,i), y_race(1,i));
end



% ADDING OBSTACLES / CIRCLES WITHIN THE TOP TUBE

%???????????????
%
% Vertex information for obstacles
%vertex_fid = fopen([mesh_name 'circ_' num2str(N) '.vertex'], 'w');
%fprintf(vertex_fid, '%d\n', Nracecirc);
%
%???????????????


% CENTER OBSTACLE
x1Center = 0;
y1Center = .15;
x1 = radius * cos(gamma) + x1Center;
y1 = radius * sin(gamma) + y1Center;
plot(x1,y1,'k.');
axis square;
grid on;

for i = 1:length(gamma)
    fprintf(vertex_fid, '%1.16e %1.16e\n', x1(1,i), y1(1,i));
end

% RIGHT TOP OBSTACLE
x2Center = 0.1;
y2Center = .18;
x2 = radius * cos(gamma) + x2Center;
y2 = radius * sin(gamma) + y2Center;
plot(x2,y2,'k.');
%plot(x,y,.1,.18,'lineWidth',3);
axis square;
grid on;

for i = 1:length(gamma)
    fprintf(vertex_fid, '%1.16e %1.16e\n', x2(1,i), y2(1,i));
end

% RIGHT BOTTOM OBSTACLE
x3Center = 0.1;
y3Center = .12;
x3 = radius * cos(gamma) + x3Center;
y3 = radius * sin(gamma) + y3Center;
plot(x3,y3,'k.');
%plot(x,y,.1,.12,'lineWidth',3);
axis square;
%grid on;

for i = 1:length(gamma)
    fprintf(vertex_fid, '%1.16e %1.16e\n', x3(1,i), y3(1,i));
end

% LEFT TOP OBSTACLE
x4Center = -0.1;
y4Center = .18;
x4 = radius * cos(gamma) + x4Center;
y4 = radius * sin(gamma) + y4Center;
plot(x4,y4,'k.');
%plot(x,y,-0.1,.18,'lineWidth',3);
axis square;
grid on;

for i = 1:length(gamma)
    fprintf(vertex_fid, '%1.16e %1.16e\n', x4(1,i), y4(1,i));
end

% LEFT BOTTOM OBSTACLE
x5Center = -0.1;
y5Center = .12;
x5 = radius * cos(gamma) + x5Center;
y5 = radius * sin(gamma) + y5Center;
plot(x5,y5,'k.');
%plot(x,y,-0.1,.12,'lineWidth',3);
axis square;
grid on;

for i = 1:length(gamma)
    fprintf(vertex_fid, '%1.16e %1.16e\n', x5(1,i), y5(1,i));
end

fclose(vertex_fid);

% Plots the racetrack vertices
plot(x_race,y_race,'k.')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the spring information for the elastic section

spring_fid = fopen([mesh_name 'tube_' num2str(N) '.spring'], 'w');
fprintf(spring_fid, '%d\n', Nstraight-2);

%elastic part of tube
for i = 0:ceil(Nstraight/2)-2
    fprintf(spring_fid, '%d %d %1.16e %1.16e\n', i, i+1, kappa_spring*ds/(ds^2), ds);
end

for i = ceil(Nstraight/2):Nstraight-2
    fprintf(spring_fid, '%d %d %1.16e %1.16e\n', i, i+1, kappa_spring*ds/(ds^2), ds);
end

fclose(spring_fid);
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Write out the beam information for the elastic section

beam_fid = fopen([mesh_name 'tube_' num2str(N) '.beam'], 'w');
fprintf(beam_fid, '%d\n', Nstraight-4);

%elastic part of tube
for i = 0:ceil(Nstraight/2)-3
    fprintf(beam_fid, '%d %d %d %1.16e\n', i, i+1, i+2, kappa_beam*ds/(ds^4));
end

for i = ceil(Nstraight/2):Nstraight-3
    fprintf(beam_fid, '%d %d %d %1.16e\n', i, i+1, i+2, kappa_beam*ds/(ds^4));
end
fclose(beam_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write out the target point information for the ends of the elastic tube
target_fid = fopen([mesh_name 'tube_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', 4*Nend);

for i = 0:Nend-1
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = ceil(Nstraight/2)-Nend:ceil(Nstraight/2)-1
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = ceil(Nstraight/2):ceil(Nstraight/2)+Nend-1
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = Nstraight-Nend:Nstraight-1
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the target point information for the racetrack
target_fid = fopen([mesh_name 'race_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', Nracecirc);

for i = 0:Nracecirc-1
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Target point information for the circles

% target_fid = fopen([mesh_name 'circ_' num2str(N) '.target'], 'w');
% 
% fprintf(target_fid, '%d\n', Nracecirc);
% 
% for i = 0:Nrace-1
%     fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
% end
% 
% fclose(target_fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write out the target point information for the actuator
%
%top prescribed peristalsis
target_fid = fopen(['pperi_top_' num2str(N) '.target'], 'w');
fprintf(target_fid, '%d\n', NLap);

for i = 0:NLap-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%bottom prescribed peristalsis
target_fid = fopen(['pperi_bot_' num2str(N) '.target'], 'w');
fprintf(target_fid, '%d\n', NLap);

for i = 0:NLap-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

% Write out the vertex information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prescribed peristalsis part
% Write out the vertex information

%top part
vertex_fid = fopen(['pperi_top_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', NLap);

for i=Na1p:Na2p,
    ytop = centery-R2;
    xtop = -Lt/2+i*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xtop, ytop);
end
fclose(vertex_fid);

%bottom part
vertex_fid = fopen(['pperi_bot_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', NLap);

for i=Na1p:Na2p,
    ybot = centery-R1;
    xbot = -Lt/2+i*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xbot, ybot);
end
fclose(vertex_fid);


