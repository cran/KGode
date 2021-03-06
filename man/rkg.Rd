% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rkg.r
\name{rkg}
\alias{rkg}
\title{The 'rkg' function}
\usage{
rkg(kkk, y_no, ktype)
}
\arguments{
\item{kkk}{ode class object.}

\item{y_no}{matrix(of size n_s*n_o) containing noisy observations. The row(of length n_s) represent the ode states and the column(of length n_o) represents the time points.}

\item{ktype}{character containing kernel type. User can choose 'rbf' or 'mlp' kernel.}
}
\value{
return list containing :
\itemize{ 
\item{} intp - list containing interpolation for each ode state.  
\item{} bbb - rkhs class objects for each ode state. }
}
\description{
This function is used to create 'rkhs' class object and estimate ode parameters using standard gradient matching.
}
\details{
Arguments of the 'rkg' function are 'ode' class, noisy observation, and kernel type. It return the interpolation for each of the ode states. The Ode parameters are estimated using gradient matching, and the results are stored in the 'ode' class as the ode_par attribute.
}
\examples{
\dontshow{
  ##examples for checks: executable in < 5 sec together with the examples above not shown to users
  ### define ode 
  toy_fun = function(t,x,par_ode){
       alpha=par_ode[1]
      as.matrix( c( -alpha*x[1]) )
   }

   toy_grlNODE= function(par,grad_ode,y_p,z_p) { 
       alpha = par[1]
       dres= c(0)
       dres[1] = sum( 2*( z_p-grad_ode)*y_p*alpha ) #sum( -2*( z_p[1,2:lm]-dz1)*z1*alpha ) 
       dres
   }

  t_no = c(0.1,1,2,3,4,8)
  n_o = length(t_no)   
  y_no =  matrix( c(exp(-t_no)),ncol=1  )
  ######################## create and initialise ode object #########################################
 init_par = rep(c(0.1))
 init_yode = t(y_no)
 init_t = t_no

 kkk = ode$new(1,fun=toy_fun,grfun=toy_grlNODE,t=init_t,ode_par= init_par, y_ode=init_yode )

 ##### standard gradient matching
 ktype='rbf'
 rkgres = rkg(kkk,(y_no),ktype)
 kkk$ode_par
}
\dontrun{
require(mvtnorm)
noise = 0.1  ## set the variance of noise
SEED = 19537
set.seed(SEED)
## Define ode function, we use lotka-volterra model in this example. 
## we have two ode states x[1], x[2] and four ode parameters alpha, beta, gamma and delta.
LV_fun = function(t,x,par_ode){
  alpha=par_ode[1]
  beta=par_ode[2]
  gamma=par_ode[3]
  delta=par_ode[4]
  as.matrix( c( alpha*x[1]-beta*x[2]*x[1] , -gamma*x[2]+delta*x[1]*x[2] ) )
}
## Define the gradient of ode function against ode parameters 
## df/dalpha,  df/dbeta, df/dgamma, df/ddelta where f is the differential equation.
LV_grlNODE= function(par,grad_ode,y_p,z_p) { 
alpha = par[1]; beta= par[2]; gamma = par[3]; delta = par[4]
dres= c(0)
dres[1] = sum( -2*( z_p[1,]-grad_ode[1,])*y_p[1,]*alpha ) 
dres[2] = sum( 2*( z_p[1,]-grad_ode[1,])*y_p[2,]*y_p[1,]*beta)
dres[3] = sum( 2*( z_p[2,]-grad_ode[2,])*gamma*y_p[2,] )
dres[4] = sum( -2*( z_p[2,]-grad_ode[2,])*y_p[2,]*y_p[1,]*delta)
dres
}

## create a ode class object
kkk0 = ode$new(2,fun=LV_fun,grfun=LV_grlNODE)
## set the initial values for each state at time zero.
xinit = as.matrix(c(0.5,1))
## set the time interval for the ode numerical solver.
tinterv = c(0,6)
## solve the ode numerically using predefined ode parameters. alpha=1, beta=1, gamma=4, delta=1.
kkk0$solve_ode(c(1,1,4,1),xinit,tinterv) 

## Add noise to the numerical solution of the ode model and use it as the noisy observation.
n_o = max( dim( kkk0$y_ode) )
t_no = kkk0$t
y_no =  t(kkk0$y_ode) + rmvnorm(n_o,c(0,0),noise*diag(2))

## Create a ode class object by using the simulation data we created from the ode numerical solver.
## If users have experiment data, they can replace the simulation data with the experiment data.
## Set initial value of ode parameters.
init_par = rep(c(0.1),4)
init_yode = t(y_no)
init_t = t_no
kkk = ode$new(1,fun=LV_fun,grfun=LV_grlNODE,t=init_t,ode_par= init_par, y_ode=init_yode )

## The following examples with CPU or elapsed time > 10s

##Use function 'rkg' to estimate the ode parameters. The standard gradient matching method is coded
##in the the 'rkg' function. The parameter estimations are stored in the returned vector of 'rkg'.
## Choose a kernel type for 'rkhs' interpolation. Two options are provided 'rbf' and 'mlp'. 
ktype ='rbf'
rkgres = rkg(kkk,y_no,ktype)
## show the results of ode parameter estimation using the standard gradient matching
kkk$ode_par
}
}
\author{
Mu Niu \email{mu.niu@glasgow.ac.uk}
}
