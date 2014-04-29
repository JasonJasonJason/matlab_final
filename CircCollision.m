function CircCollision
% Nikesh Bajaj
% bajaj.nikkey@gmail.com
% Aligarh Muslim University

    format compact

    global vel puck_size puck_radius peg_size peg_radius pos pos2 width hight walls
    width=400;
    hight =400;
    x=(width)/2;
    y=(hight)/2;
    puck_size   = 20;
    puck_radius = puck_size/2;
    peg_size    = 8;
    peg_radius  = peg_size/2; 
    
    walls = [50 150 250 250; 
             30 350 0 400; 
             0 300 30 350];

    pos = [x y];
    pos2= [x+peg_radius y-40];
    pos = [30 250];
    vel = [0 1];
    
    figure_handle = figure(1);
    while ishandle(figure_handle)
        drawcircle
    end
    disp('bye!')

function drawcircle
    global vel puck_size puck_radius peg_size peg_radius pos pos2 width hight walls

    if pos(1)+puck_size> width || pos(1)-puck_size <0
        vel(1)=-(vel(1)+0.1*vel(1));
    end
    if pos(2)+puck_size>hight || pos(2)-puck_size<0
        vel(2)=-(vel(2)+0.1*vel(2));
    end

    pos(1) = pos(1) + vel(1);
    pos(2) = pos(2) + vel(2);

    circleplot(pos(1), pos(2), puck_radius, 'r') 
    hold on
    for i = 1:3
        wall = walls(i,:);
        plot([wall(1) wall(3)], [wall(2) wall(4)]);
    end
    circleplot(pos2(1), pos2(2), peg_radius, 'b') 
    hold off
    axis([0, width, 0, hight])
    drawnow

    %Detect collision - pythagorean theorem
    a = pos(1) - pos2(1);
    b = pos(2) - pos2(2);
    distance = sqrt(a*a + b*b);
    if distance <= puck_radius + peg_radius        
        %TODO: update position to exact collision point
        
        %update velocity
        velocity_angle = radtodeg(atan2(vel(2),  vel(1)));
        normal_angle   = radtodeg(atan2(pos2(2) - pos(2), pos2(1) - pos(1)));
        velocity_angle = 2 * normal_angle - 180 - velocity_angle;
        
        vel(1) = cos(degtorad(velocity_angle)) * norm(vel);
        vel(2) = sin(degtorad(velocity_angle)) * norm(vel);
        
        disp('Collision!')
    end
    
    %Detect collision with walls
    for i = 1:3
        wall = walls(i,:);
        if wall_collision(wall) == 1
            disp('within line!')
            velocity_angle = radtodeg(atan2(vel(2),  vel(1)));
            normal_angle   = radtodeg(atan2(-(wall(3)-wall(1)), wall(4)-wall(2)));
            velocity_angle = 2 * normal_angle - 180 - velocity_angle;

            vel(1) = cos(degtorad(velocity_angle)) * norm(vel);
            vel(2) = sin(degtorad(velocity_angle)) * norm(vel);
        end
    end

function d = wall_collision(wall)
    global pos puck_radius;
    
    slope = (wall(4)-wall(2)) / (wall(3)-wall(1));
    intercept = slope * -wall(1) + wall(2);
    [xout,yout] = linecirc(slope, intercept, pos(1), pos(2), puck_radius);
    
    if xout(1) > wall(1) && xout(1) < wall(3) && yout(1) > wall(2) && yout(2) < wall(4)
        d = 1;
        return
    else
        d = 0;
        return
    end

function circleplot(xc, yc, r, color) 
    t = 0 : .1 : 2*pi; 
    x = r * cos(t) + xc; 
    y = r * sin(t) + yc; 
    plot(x, y, color) 
    axis square; grid 