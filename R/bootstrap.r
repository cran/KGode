
#' The 'bootstrap' function
#'
#' This function is used to perform bootstrap procedure to estimate parameter uncertainty.
#'
#' Arguments of the 'bootstrap' function are 'ode' class, noisy observation, kernel type, the set of parameters that have been estimated before using gradient matching, a list of interpolations for each of the ode state from gradient matching, and the warping object (if warping has been performed). It returns a vector of the median absolute standard deviations for each ode state, computed from the bootstrap replicates.
#' @import stats
#' @param kkk ode class object.
#' @param y_no matrix(of size n_s*n_o) containing noisy observations. The row(of length n_s) represent the ode states and the column(of length n_o) represents the time points.
#' @param ktype character containing kernel type. User can choose 'rbf' or 'mlp' kernel.
#' @param K the number of bootstrap replicates to collect.
#' @param ode_par a vector of ode parameters estimated using gradient matching.
#' @param intp_data a list of interpolations produced by gradient matching for each ode state.
#' @param www an optional warping object (if warping has been performed using warpfun).
#' @return return a vector of the median absolute deviation (MAD) for each ode state.
#' @export
#' @examples
#'\dontshow{
#'   ##examples for checks: executable in < 5 sec together with the examples above not shown to users
#'   ### define ode
#'   toy_fun = function(t,x,par_ode){
#'        alpha=par_ode[1]
#'       as.matrix( c( -alpha*x[1]) )
#'    }
#'
#'    toy_grlNODE= function(par,grad_ode,y_p,z_p) {
#'        alpha = par[1]
#'        dres= c(0)
#'        dres[1] = sum( 2*( z_p-grad_ode)*y_p*alpha ) #sum( -2*( z_p[1,2:lm]-dz1)*z1*alpha )
#'        dres
#'    }
#'
#'   t_no = c(0.1,1,2,3,4,8)
#'   n_o = length(t_no)
#'   y_no =  matrix( c(exp(-t_no)),ncol=1  )
#'   ######################## create and initialise ode object #########################################
#'  init_par = rep(c(0.1))
#'  init_yode = t(y_no)
#'  init_t = t_no
#'
#'  kkk = ode$new(1,fun=toy_fun,grfun=toy_grlNODE,t=init_t,ode_par= init_par, y_ode=init_yode )
#'
#'  ##### standard gradient matching
#'  ktype='rbf'
#'  rkgres = rkg(kkk,(y_no),ktype)
#'  ode_par = kkk$ode_par
#'
#' ######################## perform bootstrap #########################################
#' bbb = rkgres$bbb
#' nst = length(bbb)
#' K = 3
#' intp_data = list()
#' for( i in 1:nst) {
#'     intp_data[[i]] = bbb[[i]]$predictT(bbb[[i]]$t)$pred
#' }
#' mads = bootstrap(kkk, y_no, ktype, K, ode_par, intp_data)
#' mads
#'}
#'\dontrun{
#' require(mvtnorm)
#' noise = 0.1  ## set the variance of noise
#' SEED = 19537
#' set.seed(SEED)
#' ## Define ode function, we use lotka-volterra model in this example.
#' ## we have two ode states x[1], x[2] and four ode parameters alpha, beta, gamma and delta.
#' LV_fun = function(t,x,par_ode){
#'   alpha=par_ode[1]
#'   beta=par_ode[2]
#'   gamma=par_ode[3]
#'   delta=par_ode[4]
#'   as.matrix( c( alpha*x[1]-beta*x[2]*x[1] , -gamma*x[2]+delta*x[1]*x[2] ) )
#' }
#' ## Define the gradient of ode function against ode parameters
#' ## df/dalpha,  df/dbeta, df/dgamma, df/ddelta where f is the differential equation.
#' LV_grlNODE= function(par,grad_ode,y_p,z_p) {
#' alpha = par[1]; beta= par[2]; gamma = par[3]; delta = par[4]
#' dres= c(0)
#' dres[1] = sum( -2*( z_p[1,]-grad_ode[1,])*y_p[1,]*alpha )
#' dres[2] = sum( 2*( z_p[1,]-grad_ode[1,])*y_p[2,]*y_p[1,]*beta)
#' dres[3] = sum( 2*( z_p[2,]-grad_ode[2,])*gamma*y_p[2,] )
#' dres[4] = sum( -2*( z_p[2,]-grad_ode[2,])*y_p[2,]*y_p[1,]*delta)
#' dres
#' }
#'
#' ## create a ode class object
#' kkk0 = ode$new(2,fun=LV_fun,grfun=LV_grlNODE)
#' ## set the initial values for each state at time zero.
#' xinit = as.matrix(c(0.5,1))
#' ## set the time interval for the ode numerical solver.
#' tinterv = c(0,6)
#' ## solve the ode numerically using predefined ode parameters. alpha=1, beta=1, gamma=4, delta=1.
#' kkk0$solve_ode(c(1,1,4,1),xinit,tinterv)
#'
#' ## Add noise to the numerical solution of the ode model and use it as the noisy observation.
#' n_o = max( dim( kkk0$y_ode) )
#' t_no = kkk0$t
#' y_no =  t(kkk0$y_ode) + rmvnorm(n_o,c(0,0),noise*diag(2))
#'
#' ## Create a ode class object by using the simulation data we created from the ode numerical solver.
#' ## If users have experiment data, they can replace the simulation data with the experiment data.
#' ## Set initial value of ode parameters.
#' init_par = rep(c(0.1),4)
#' init_yode = t(y_no)
#' init_t = t_no
#' kkk = ode$new(1,fun=LV_fun,grfun=LV_grlNODE,t=init_t,ode_par= init_par, y_ode=init_yode )
#'
#' ## The following examples with CPU or elapsed time > 10s
#'
#' ##Use function 'rkg' to estimate the ode parameters. The standard gradient matching method is coded
#' ##in the the 'rkg' function. The parameter estimations are stored in the returned vector of 'rkg'.
#' ## Choose a kernel type for 'rkhs' interpolation. Two options are provided 'rbf' and 'mlp'.
#' ktype ='rbf'
#' rkgres = rkg(kkk,y_no,ktype)
#' ## show the results of ode parameter estimation using the standard gradient matching
#' kkk$ode_par
#'
#' ## Perform bootstrap procedure to estimate the median absolute deviations of ode parameters
#' # here we get the resulting interpolation from gradient matching using 'rkg' for each ode state
#' bbb = rkgres$bbb
#' nst = length(bbb)
#' intp_data = list()
#' for( i in 1:nst) {
#'     intp_data[[i]] = bbb[[i]]$predictT(bbb[[i]]$t)$pred
#' }
#' K = 12 # the number of bootstrap replicates
#' mads = bootstrap(kkk, y_no, ktype, K, ode_par, intp_data)
#'
#' ## show the results of ode parameter estimation and its uncertainty
#' ## using the standard gradient matching
#' ode_par
#' mads
#'
#' ############# gradient matching + ODE regularisation
#' crtype='i'
#' lam=c(10,1,1e-1,1e-2,1e-4)
#' lamil1 = crossv(lam,kkk,bbb,crtype,y_no)
#' lambdai1=lamil1[[1]]
#' res = third(lambdai1,kkk,bbb,crtype)
#' oppar = res$oppar
#'
#' ### do bootstrap here for gradient matching + ODE regularisation
#' ode_par = oppar
#' K = 12
#' intp_data = list()
#' for( i in 1:nst) {
#'     intp_data[[i]] = res$rk3$rk[[i]]$predictT(bbb[[i]]$t)$pred
#' }
#' mads = bootstrap(kkk, y_no, ktype, K, ode_par, intp_data)
#' ode_par
#' mads
#'
#' ############# gradient matching + ODE regularisation + warping
#' ###### warp state
#' peod = c(6,5.3) #8#9.7     ## the guessing period
#' eps= 1          ## the standard deviation of period
#' fixlens=warpInitLen(peod,eps,rkgres)
#' kkkrkg = kkk$clone()
#' www = warpfun(kkkrkg,bbb,peod,eps,fixlens,y_no,kkkrkg$t)
#'
#' ### do bootstrap here for gradient matching + ODE regularisation + warping
#' nst = length(bbb)
#' K = 12
#' ode_par = www$wkkk$ode_par
#' intp_data = list()
#' for( i in 1:nst) {
#'     intp_data[[i]] = www$bbbw[[i]]$predictT(www$wtime[i, ])$pred
#' }
#' mads = bootstrap(kkk, y_no, ktype, K, ode_par, intp_data,www)
#' ode_par
#' mads
#' 
#'}
#' @author Mu Niu \email{mu.niu@glasgow.ac.uk}
bootstrap <- function(kkk, y_no, ktype, K, ode_par, intp_data, www=NULL) {
    intp = do.call(rbind, intp_data) # convert from list of lists to array
    ode_pars=c()
    for ( i in 1:K )
    {
        # compute residuals
        residuals = kkk$y_ode - intp

        # sample with replacement
        resampled_residuals = t(apply(residuals, 1, function(row) sample(row, length(row), replace=TRUE)))

        # add to interpolation
        resampled_data = intp + resampled_residuals

        # make a new kkk object with the resampled data
        new_kkk = ode$new(1, fun=kkk$ode_fun, grfun=kkk$gr_lNODE, t=kkk$t,
                          ode_par=ode_par, y_ode=resampled_data)

        # run gradient matching again
        if(is.null(www)) {
            x = rkg(new_kkk, t(resampled_data), ktype)
        } else {
            ### learn interpolates in warped time domain
            intpl = c()
            gradl = c()
            nst = nrow(kkk$y_ode)
            n_o = max(dim(kkk$y_ode))
            for( st in 1:nst) {
                new_rbf= RBF$new(1)
                wk = rkhs$new(resampled_data[st,], www$wtime[st,], rep(1, n_o), 1, new_rbf)
                wk$skcross(5)
                intpl = rbind(intp, wk$predict()$pred)
                gradl = rbind(gradl, wk$predict()$grad*www$dtilda[st,])
            }
            inipar = rep(0.1, length(new_kkk$ode_par))
            new_kkk$optim_par(inipar, intpl, gradl)
        }

        new_ode_par = new_kkk$ode_par
        ode_pars = rbind(ode_pars, new_ode_par)
    }

    # compute median absolute standard deviation from the bootstrap replicates
    mads = apply(ode_pars, 2, stats::mad)
    return(mads)
}
