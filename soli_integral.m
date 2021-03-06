% Evaluate the soliton integral for m = 1
%
% u - function value sought
% A - soli amplitude
% n - permeability power law
% tol - tolerance of calculation
%
function int = soli_integral(u,A,n,tol)

  % Some special function values 
  gpA = (2*A^(1 - n)*(-A - A^(2*n) + ...
                      A^n*(1 + A + (-1 + A)*(-1 + n)*n*log(A))))/...
        (-1 + n + A^n*(-1 + n)*(-1 + n*log(A)));
  gppA = (-6*A^(2*n) + 4*A*(-2 + n) - ...
          2*A^n*(-3 + n^2 - A*(4 + (-2 + n)*n) + ...
                 (3 + A*(-4 + n) - n)*(-1 + n)*n* ...
                 log(A)))/(A^n*(-1 + n)*(1 + A^n*(-1 + n*log(A))));
  gpp1 = (2*(-1 + A^n*(1 - 2*n) + 2*n + ...
             (-1 + A)*n^2 + A^n*(-1 + n)*n*log(A)))/...
         (-1 + n + A^n*(-1 + n)*(-1 + n*log(A)));
  gppp1 = (2*(-4 + 9*n + n^2*(-6 - A*(-3 + n) + n) + ...
              A^n*(4 + 3*(-3 + n)*n) - ...
              2*A^n*(-2 + n)*(-1 + n)*n*log(A)))/...
          (-1 + n + A^n*(-1 + n)*(-1 + n*log(A)));
  gpppp1 = (2*(-((-1 + n)^2*(2 + (-4 + n)*n)) + A*n^2*(-1 + (-2 + n)*n) + ...
			   A^n*(2 - 4*(-2 + n)*(-1 + n)*n) + ...
			   A^n*(-2 + n)*(-1 + n)*n*(-1 + 3*n)*log(A)))/...
	(-1 + n + A^n*(-1 + n)*(-1 + n*log(A)));

  % Cutoffs for integration domains
  mu = max(0,sqrt(eps/(sqrt(2)*gpp1*tol))-(u-1));
  epsilon = sqrt(0.5*A*eps/(sqrt(-gpA*tol)));
  
  
  % Perform the integration over three different regions
  if u > A-epsilon % I3 only
     int = 2*sqrt(A-u)/sqrt(-gpA) - gppA*(A-u)^1.5/(6*(-gpA)^1.5);
  else
    int = 2*sqrt(epsilon)/sqrt(-gpA) - gppA*epsilon^1.5/(6*(-gpA)^1.5);
    if mu == 0 % I2 + I3
      int = int + quadl(@(w) 1./sqrt(g(w,A,n)),u,A-epsilon,tol);
    else % I1 + I2 + I3
      int = int + quadl(@(w) 1./sqrt(g(w,A,n)),u+mu,A-epsilon,tol);
      int = int + log((u+mu-1)/(u-1))/sqrt(0.5*gpp1) - ...
                  sqrt(2)*gppp1*mu/(6*gpp1^1.5);
    end
  end

  
function f = g(u,A,n)
  f = (2.*u.^(2-n).*(A+A.^n.*(-1+u)-u+u.^n-...
                  A.*u.^n+A.^n.*(-1+n-n.*u+u.^n).*log(A)-...
                  (-1+A.^n+n-A.*n).*u.^n.*log(u)))./...
      (-1+n+A.^n.*(-1+n).*(-1+n.*log(A)));
  
