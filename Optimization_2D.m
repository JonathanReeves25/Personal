clear

f1 = figure(1);
clf
grid on
hold on
f1.Position = [0 0 960 960];
title("Objective Funcion Value")
xlabel("Flange Length (in)")
ylabel("Web Length (in)")
colormap(jet)
colorbar

f2 = figure(2);
clf
grid on
hold on
title("Residual of Objective Function")
xlabel("Iteration")
ylabel("|obj_n - obj_n_-_1|")
set(gca, 'YScale', 'log')
f2.Position = [961 0 960 960];

f3 = figure(3);
clf
grid on
hold on
title("Max Objective Function Value per Grid")
xlabel("Iteration")
f3.Position = [961 0 960 960];

Optimize(0.5,.8,0.5,10,15,.5);

function [ll1, ul1, ll2, ul2] = Optimize(ll1,ul1,ll2,ul2,resolution,scale,ogll1,ogll2,ogul1,ogul2,resarr,itter,obfarr,prevresult,maxvar1,maxvar2)
    %% Variable initialization
    if(nargin() < 7)
        ogll1 = ll1;
    end
    if(nargin() < 8)
        ogul1 = ul1;
    end
    if(nargin() < 9)
        ogll2 = ll2;
    end
    if(nargin() < 10)
        ogul2 = ul2;
    end
    if(nargin() < 11)
        resarr = [];
    end
    if(nargin() < 12)
        itter = [];
    end
    if(nargin() < 13)
        obfarr = [];
    end
    if(nargin() < 14)
        prevresult = 0;
    end
    if(nargin() < 15)
        maxvar1 = [];
    end
    if(nargin() < 16)
        maxvar2 = [];
    end
    
    %% Initialize Mesh and plot arrays
    fine1 = abs(ll1-ul1)/resolution;
    var1 = ll1:fine1:ul1;
    fine2 = abs(ll2-ul2)/resolution;
    var2 = ll2:fine2:ul2;

    sw = zeros(length(var1),length(var2));
    
    %% Initialize loop variables
    largest = 0;
    locmax1 = (ul1-ll1)/2;
    locmax2 = (ul2-ll2)/2;
    
    %% Loop through calculating values at every node and find the highest.
    for(i = 1:length(var1))
        for(j = 1:length(var2))
% Edit Objective function here
            a = AnalyzeBuckling(var1(i),var2(j));
% Edit Objective function here
            if(a < AnalyzeBuckling(1,1.5)*1.1)
                sw(i,j) = a;
            else
                sw(i,j) = -inf;
            end
            if(largest < sw(i,j))
                largest = sw(i,j);
                locmax1 = var1(i);
                locmax2 = var2(j);
            end
        end
    end
    
    %% Calculate and print the latest residual
    res = abs(prevresult-largest);
    fprintf("Residual: %0.2e\n",res)
    
    %% Append latest values to the residual, itteration counter, and objective function arrays
    if(isempty(maxvar1))
        maxvar1(1) = locmax1;
    else
        maxvar1(end+1) = locmax1;
    end
    if(isempty(maxvar2))
        maxvar2(1) = locmax2;
    else
        maxvar2(end+1) = locmax2;
    end
    
    if(isempty(resarr))
        resarr(1) = res;
    else
        resarr(end+1) = res;
    end
    if(isempty(itter))
        itter(1) = 1;
    else
        itter(end + 1) = itter(end) + 1;
    end
    if(isempty(obfarr))
        obfarr(1) = largest;
    else
        obfarr(end + 1) = largest;
    end
    
    %% Fill array for search area plot and coloring
    loop = 1;
    for(i = var1)
        for(j = var2)
            a(loop) = i;
            b(loop) = j;
            loop = loop + 1;
        end
    end
    loop = 1;
    for(i = 1:length(var1))
        for(j = 1:length(var2))
            c(loop) = sw(i,j);
            loop = loop + 1;
        end
    end
    
    %% Plot the serch plane for this itteration
    figure(1)
    scatter(a,b,100,c,".")
    plot([min(var1),max(var1),max(var1),min(var1),min(var1)],[min(var2),min(var2),max(var2),max(var2),min(var2)],"k-")
    axis([ogll1 ogul1 ogll1 ogul2])
    
     %% Plot the next point on the residuals graph
     figure(2)
     plot(itter,resarr,"-k.",'MarkerSize',12)

    %% Deterimne Convergance
    if(res < 10^-6)
        fprintf("\nMaximum = %0.2f @ (%0.2f,%0.2f)\n",largest,locmax1,locmax2)
        %% Plot the next point on the residuals graph
        figure(2)
        plot(itter,resarr,"-k.",'MarkerSize',12)

        %% Plot the next objective function value
        figure(3)
        plot(itter,obfarr,"-k.",'MarkerSize',12)
        return
    end
    
    %% Calculate Next Mesh Limits
    temp = abs(ll1 - ul1)*.5*scale;
    ll1 = locmax1-temp;
    ul1 = locmax1+temp;
    temp = abs(ll2 - ul2)*.5*scale;
    ll2 = locmax2-temp;
    ul2 = locmax2+temp;

    if(ll1 < ogll1)
        ll1 = ll1 + abs(ll1 - ogll1);
        ul1 = ul1 + abs(ll1 - ogll1);
    end
    if(ul1 > ogul1)
        ll1 = ll1 - abs(ul1 - ogul1);
        ul1 = ul1 - abs(ul1 - ogul1);
    end
    if(ll2 < ogll2)
        ll2 = ll2 + abs(ll2 - ogll2);
        ul2 = ul2 + abs(ll2 - ogll2);
    end
    if(ul2 > ogul2)
        ll2 = ll2 - abs(ul2 - ogul2);
        ul2 = ul2 - abs(ul2 - ogul2);
    end
    
    Optimize(ll1,ul1,ll2,ul2,resolution,scale,ogll1,ogll2,ogul1,ogul2,resarr,itter,obfarr,largest,maxvar1,maxvar2);
end