clf
grid on
hold on
load Constants.mat

%Set whether to show the original grid, the outter x and y bounds and the
%distance between each grid line.
orig = true;
bound = 10;
res = 1;

a = linspace(-bound,bound,res*bound+1);
b = a';
b = b .*1i;

cmp = {b+a,(b+a)'};

if(orig == true)
    plot(cmp{1}, "r");
    plot(cmp{2}, "b");
end

%Complex Function
ncmp{1} = cmp{1}.^2;
ncmp{2} = cmp{2}.^2;

plot(ncmp{1}, "m");
plot(ncmp{2}, "c");

axis([-bound, bound, -bound, bound])