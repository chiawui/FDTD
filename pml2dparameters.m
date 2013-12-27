%PML parameters
npml=8;
ihx=zeros(ie,je);ihy=zeros(ie,je);
gi2 = ones(1,ie);
gi3 = ones(1,ie);
fi1 = zeros(1,ie);
fi2 = ones(1,ie);
fi3 = ones(1,ie);

gj2 = ones(1,je);
gj3 = ones(1,je);
fj1 = zeros(1,je);
fj2 = ones(1,je);
fj3 = ones(1,je);

%Calculate PML
for i = 1:npml+1
    xnum = npml - (i-1);
    xd = npml;
    xxn = xnum/xd;
    xn = 0.33*(xxn^3);
    gi2(i) = 1.0/(1.0+xn);
    gi2(ie-i+1) = 1.0/(1.0+xn);
    gi3(i) = (1.0 - xn)/(1.0+xn);
    gi3(ie-i+1) = (1.0 - xn)/(1.0+xn);
    
    xxn = (xnum - 0.5)/xd;
    xb = 0.25*(xxn^3);
    fi1(i) = xn;
    fi1(ie-i) = xn;
    fi2(i) = 1.0/(1.0+xn);
    fi2(ie-i) = 1.0/(1.0+xn);
    fi3(i) = (1.0-xn)/(1.0 + xn);
    fi3(ie-i) = (1.0-xn)/(1.0+xn);
end
for j = 1:npml+1
    xnum = npml - (j-1);
    xd = npml;
    xxn = xnum/xd;
    xn = 0.33*(xxn^3);
    gj2(j) = 1.0/(1.0+xn);
    gj2(je-j+1) = 1.0/(1.0+xn);
    gj3(j) = (1.0 - xn)/(1.0+xn);
    gj3(je-j+1) = (1.0 - xn)/(1.0+xn);
    
    xxn = (xnum - 0.5)/xd;
    xb = 0.25*(xxn^3);
    fj1(j) = xn;
    fj1(je-j) = xn;
    fj2(j) = 1.0/(1.0+xn);
    fj2(je-j) = 1.0/(1.0+xn);
    fj3(j) = (1.0-xn)/(1.0 + xn);
    fj3(je-j) = (1.0-xn)/(1.0+xn);
end