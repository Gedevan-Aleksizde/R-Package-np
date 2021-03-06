\name{npudistbw}
\alias{npudistbw}
\alias{npudistbw.formula}
\alias{npudistbw.NULL}
\alias{npudistbw.default}
\alias{npudistbw.dbandwidth}
\title{Kernel Distribution Bandwidth Selection with Mixed Data Types}

\description{
  \code{npudistbw} computes a bandwidth object for a \eqn{p}-variate
  kernel cumulative distribution estimator defined over mixed continuous
  and discrete (ordered) data using either the normal reference
  rule-of-thumb or least-squares cross validation using the method of
  Li, Li and Racine (2017).
}

\usage{

npudistbw(\dots)

\method{npudistbw}{formula}(formula, data, subset, na.action, call, gdata = NULL,\dots)

\method{npudistbw}{NULL}(dat = stop("invoked without input data 'dat'"),
          bws,
          \dots)

\method{npudistbw}{dbandwidth}(dat = stop("invoked without input data 'dat'"),
          bws,
          gdat = NULL,
          bandwidth.compute = TRUE,
          nmulti,
          remin = TRUE,
          itmax = 10000,
          do.full.integral = FALSE,
          ngrid = 100,
          ftol = 1.490116e-07,
          tol = 1.490116e-04,
          small = 1.490116e-05,
          lbc.dir = 0.5,
          dfc.dir = 3,
          cfac.dir = 2.5*(3.0-sqrt(5)),
          initc.dir = 1.0,
          lbd.dir = 0.1,
          hbd.dir = 1,
          dfac.dir = 0.25*(3.0-sqrt(5)),
          initd.dir = 1.0,
          lbc.init = 0.1,
          hbc.init = 2.0,
          cfac.init = 0.5,
          lbd.init = 0.1,
          hbd.init = 0.9,
          dfac.init = 0.375, 
          scale.init.categorical.sample = FALSE,
          memfac = 500.0,
          \dots)

\method{npudistbw}{default}(dat = stop("invoked without input data 'dat'"),
          bws,
          gdat,
          bandwidth.compute = TRUE,
          nmulti,
          remin,
          itmax,
          do.full.integral,
          ngrid,
          ftol,
          tol,
          small,
          lbc.dir,
          dfc.dir,
          cfac.dir,
          initc.dir,
          lbd.dir,
          hbd.dir,
          dfac.dir,
          initd.dir,
          lbc.init,
          hbc.init,
          cfac.init,
          lbd.init,
          hbd.init,
          dfac.init,
          scale.init.categorical.sample,
          memfac,
          bwmethod,
          bwscaling,
          bwtype,
          ckertype,
          ckerorder,
          okertype,
          \dots) 

}

\arguments{
  \item{formula}{
    a symbolic description of variables on which bandwidth selection is
    to be performed. The details of constructing a formula are
    described below.
  }

  \item{data}{
    an optional data frame, list or environment (or object coercible to
    a data frame by \code{\link{as.data.frame}}) containing the
    variables in the model. If not found in data, the variables are
    taken from \code{environment(formula)}, typically the environment
    from which the function is called.
  }

  \item{subset}{
    an optional vector specifying a subset of observations to be used in
    the fitting process. 
  }

  \item{na.action}{
    a function which indicates what should happen when the data contain
   \code{NA}s. The default is set by the \code{\link{na.action}} setting
   of options, and is \code{\link{na.fail}} if that is unset. The
   (recommended) default is \code{\link{na.omit}}.
  }
  
  \item{call}{
    the original function call. This is passed internally by
    \code{\link{np}} when a bandwidth search has been implied by a call to
    another function. It is not recommended that the user set this.
  }
    
  \item{gdata}{
    a grid of data on which the indicator function for
    least-squares cross-validation is to be computed (can be the sample
    or a grid of quantiles).
  }

  \item{dat}{
    a \eqn{p}-variate data frame on which bandwidth selection will be
    performed. The data types may be continuous, discrete (ordered
    factors), or some combination thereof.
  }

  \item{bws}{
    a bandwidth specification. This can be set as a bandwidth object
    returned from a previous invocation, or as a vector of bandwidths,
    with each element \eqn{i} corresponding to the bandwidth for column
    \eqn{i} in \code{dat}. In either case, the bandwidth supplied will
    serve as a starting point in the numerical search for optimal
    bandwidths. If specified as a vector, then additional arguments will
    need to be supplied as necessary to specify the bandwidth type,
    kernel types, selection methods, and so on. This can be left unset.
  }

  \item{gdat}{
    a grid of data on which the indicator function for
    least-squares cross-validation is to be computed (can be the sample
    or a grid of quantiles).
  }

  \item{\dots}{
    additional arguments supplied to specify the bandwidth type,
    kernel types, selection methods, and so on, detailed below.
  }
  
  \item{bwmethod}{ a character string specifying the bandwidth selection
    method.  \code{cv.cdf} specifies least-squares cross-validation for
    cumulative distribution functions (Li, Li and Racine (2017)), and
    \code{normal-reference} just computes the \sQuote{rule-of-thumb}
    bandwidth \eqn{h_j}{h[j]} using the standard formula \eqn{h_j =
    1.587 \sigma_j n^{-1/(P+l)}}{h[j] = 1.587*sigma[j]*n^(-1.0/(P+l))},
    where \eqn{\sigma_j}{sigma[j]} is an adaptive measure of spread of
    the \eqn{j}th continuous variable defined as min(standard deviation,
    mean absolute deviation/1.4826, interquartile range/1.349), \eqn{n}
    the number of observations, \eqn{P} the order of the kernel, and
    \eqn{l} the number of continuous variables. Note that when there
    exist factors and the normal-reference rule is used, there is zero
    smoothing of the factors. Defaults to \code{cv.cdf}.  }

  \item{bwscaling}{ a logical value that when set to \code{TRUE} the
    supplied bandwidths are interpreted as `scale factors'
    (\eqn{c_j}{c[j]}), otherwise when the value is \code{FALSE} they are
    interpreted as `raw bandwidths' (\eqn{h_j}{h[j]} for continuous data
    types, \eqn{\lambda_j}{lambda[j]} for discrete data types). For
    continuous data types, \eqn{c_j}{c[j]} and \eqn{h_j}{h[j]} are
    related by the formula \eqn{h_j = c_j \sigma_j n^{-1/(P+l)}}{h[j] =
    c[j]*sigma[j]*n^(-1/(P+l))}, where \eqn{\sigma_j}{sigma[j]} is an
    adaptive measure of spread of the \eqn{j}th continuous variable
    defined as min(standard deviation, mean absolute deviation/1.4826,
    interquartile range/1.349), \eqn{n} the number of observations,
    \eqn{P}{P} the order of the kernel, and \eqn{l}{l} the number of
    continuous variables. For discrete data types, \eqn{c_j}{c[j]} and
    \eqn{h_j}{h[j]} are related by the formula \eqn{h_j =
    c_jn^{-2/(P+l)}}{h[j] = c[j]*n^(-2/(P+l))}, where here \eqn{j}{[j]}
    denotes discrete variable \eqn{j}{j}.  Defaults to \code{FALSE}.  }

  \item{bwtype}{
    character string used for the continuous variable bandwidth type,
    specifying the type of bandwidth to compute and return in the
    \code{bandwidth} object. Defaults to \code{fixed}. Option
    summary:\cr
    \code{fixed}: compute fixed bandwidths \cr
    \code{generalized_nn}: compute generalized nearest neighbors \cr
    \code{adaptive_nn}: compute adaptive nearest neighbors
    
  }

  \item{bandwidth.compute}{
    a logical value which specifies whether to do a numerical search for
    bandwidths or not. If set to \code{FALSE}, a \code{bandwidth} object
    will be returned with bandwidths set to those specified
    in \code{bws}. Defaults to \code{TRUE}.
  }
  

  \item{ckertype}{
    character string used to specify the continuous kernel type.
    Can be set as \code{gaussian}, \code{epanechnikov}, or
    \code{uniform}. Defaults to \code{gaussian}.
  }

  \item{ckerorder}{
    numeric value specifying kernel order (one of
    \code{(2,4,6,8)}). Kernel order specified along with a
  \code{uniform} continuous kernel type will be ignored. Defaults to
  \code{2}.
  }

  \item{okertype}{
    character string used to specify the ordered categorical kernel type.
    Can be set as \code{wangvanryzin}.
  }

  \item{nmulti}{
    integer number of times to restart the process of finding extrema of
    the cross-validation function from different (random) initial points.
  }

  \item{remin}{
    a logical value which when set as \code{TRUE} the search routine
    restarts from located minima for a minor gain in accuracy. Defaults
    to \code{TRUE}.
  }

  \item{itmax}{
    integer number of iterations before failure in the numerical
    optimization routine. Defaults to \code{10000}.
  }

  \item{do.full.integral}{
    a logical value which when set as \code{TRUE} evaluates the
    moment-based integral on the entire sample. Defaults
    to \code{FALSE}.
  }

  \item{ngrid}{
    integer number of grid points to use when computing the moment-based
    integral. Defaults to \code{100}.
  }

  \item{ftol}{
    fractional tolerance on the value of the cross-validation function
    evaluated at located minima (of order the machine precision or
    perhaps slightly larger so as not to be diddled by
    roundoff). Defaults to \code{1.490116e-07}
    (1.0e+01*sqrt(.Machine$double.eps)).
  }

  \item{tol}{
    tolerance on the position of located minima of the cross-validation
    function (tol should generally be no smaller than the square root of
    your machine's floating point precision). Defaults to \code{
      1.490116e-04 (1.0e+04*sqrt(.Machine$double.eps))}.
  }

  \item{small}{
    a small number used to bracket a minimum (it is hopeless to ask for
    a bracketing interval of width less than sqrt(epsilon) times its
    central value, a fractional width of only about 10-04 (single
    precision) or 3x10-8 (double precision)). Defaults to \code{small
      = 1.490116e-05 (1.0e+03*sqrt(.Machine$double.eps))}.
  }

  \item{lbc.dir,dfc.dir,cfac.dir,initc.dir}{ lower bound, chi-square
    degrees of freedom, stretch factor, and initial non-random values
    for direction set search for Powell's algorithm for \code{numeric}
    variables. See Details}

  \item{lbd.dir,hbd.dir,dfac.dir,initd.dir}{ lower bound, upper bound,
    stretch factor, and initial non-random values for direction set
    search for Powell's algorithm for categorical variables. See
    Details}

  \item{lbc.init, hbc.init, cfac.init}{ lower bound, upper bound, and
    non-random initial values for scale factors for \code{numeric}
    variables for Powell's algorithm. See Details}

  \item{lbd.init, hbd.init, dfac.init}{ lower bound, upper bound, and
    non-random initial values for scale factors for categorical
    variables for Powell's algorithm. See Details}

  \item{scale.init.categorical.sample}{ a logical value that when set
    to \code{TRUE} scales \code{lbd.dir}, \code{hbd.dir},
    \code{dfac.dir}, and \code{initd.dir} by \eqn{n^{-2/(2P+l)}},
    \eqn{n} the number of observations, \eqn{P}{P} the order of the
    kernel, and \eqn{l}{l} the number of \code{numeric} variables. See
    Details}

  \item{memfac}{
    The algorithm to compute the least-squares objective function uses
    a block-based algorithm to eliminate or minimize redundant kernel
    evaluations. Due to memory, hardware and software constraints, a
    maximum block size must be imposed by the algorithm. This block size
    is roughly equal to memfac*10^5 elements. Empirical tests on
    modern hardware find that a memfac of 500 performs well. If
    you experience out of memory errors, or strange behaviour for
    large data sets (>100k elements) setting memfac to a lower value may
    fix the problem.
  }
}

\details{

  Typical usages are (see below for a complete list of options and also
  the examples at the end of this help file)
  \preformatted{
    
    Usage 1: compute a bandwidth object using the formula interface:
    
    bw <- npudistbw(~y)
    
    Usage 2: compute a bandwidth object using the data frame interface
    and change the default kernel and order:

    Fhat <- npudistbw(tdat = y, ckertype="epanechnikov", ckerorder=4)
    
  }

  
  \code{npudistbw} implements a variety of methods for choosing
  bandwidths for multivariate (\eqn{p}-variate) distributions defined
  over a set of possibly continuous and/or discrete (ordered) data. The
  approach is based on Li and Racine (2003) who employ
  \sQuote{generalized product kernels} that admit a mix of continuous
  and discrete data types.

  The cross-validation methods employ multivariate numerical search
  algorithms (direction set (Powell's) methods in multidimensions).

  Bandwidths can (and will) differ for each variable which is, of
  course, desirable.

  Three classes of kernel estimators for the continuous data types are
  available: fixed, adaptive nearest-neighbor, and generalized
  nearest-neighbor. Adaptive nearest-neighbor bandwidths change with
  each sample realization in the set, \eqn{x_i}{x[i]}, when estimating the
  cumulative distribution at the point \eqn{x}. Generalized nearest-neighbor bandwidths change
  with the point at which the cumulative distribution is estimated, \eqn{x}. Fixed bandwidths
  are constant over the support of \eqn{x}.

  \code{npudistbw} may be invoked \emph{either} with a formula-like
  symbolic description of variables on which bandwidth selection is to
  be performed \emph{or} through a simpler interface whereby data is
  passed directly to the function via the \code{dat} parameter. Use of
  these two interfaces is \bold{mutually exclusive}.

  Data contained in the data frame \code{dat} may be a mix of continuous
  (default) and ordered discrete (to be specified in the data frame
  \code{dat} using \code{\link{ordered}}). Data can be entered in an
  arbitrary order and data types will be detected automatically by the
  routine (see \code{\link{np}} for details).

  Data for which bandwidths are to be estimated may be specified
  symbolically. A typical description has the form \code{~ data}, where
  \code{data} is a series of variables specified by name, separated by
  the separation character '+'. For example, \code{ ~ x + y } specifies
  that the bandwidths for the joint distribution of variables \code{x}
  and \code{y} are to be estimated. See below for further examples.

  A variety of kernels may be specified by the user. Kernels implemented
  for continuous data types include the second, fourth, sixth, and
  eighth-order Gaussian and Epanechnikov kernels, and the uniform
  kernel. Ordered data types use a variation of the Wang and van Ryzin
  (1981) kernel.

  The optimizer invoked for search is Powell's conjugate direction
  method which requires the setting of (non-random) initial values and
  search directions for bandwidths, and when restarting, random values
  for successive invocations. Bandwidths for \code{numeric} variables
  are scaled by robust measures of spread, the sample size, and the
  number of \code{numeric} variables where appropriate. Two sets of
  parameters for bandwidths for \code{numeric} can be modified, those
  for initial values for the parameters themselves, and those for the
  directions taken (Powell's algorithm does not involve explicit
  computation of the function's gradient). The default values are set by
  considering search performance for a variety of difficult test cases
  and simulated cases. We highly recommend restarting search a large
  number of times to avoid the presence of local minima (achieved by
  modifying \code{nmulti}). Further refinement for difficult cases can
  be achieved by modifying these sets of parameters. However, these
  parameters are intended more for the authors of the package to enable
  \sQuote{tuning} for various methods rather than for the user them
  self.

}
\value{
  \code{npudistbw} returns a \code{bandwidth} object with the
  following components:

  \item{bw}{ bandwidth(s), scale factor(s) or nearest neighbours for the
    data, \code{dat} }
  \item{fval}{ objective function value at minimum }

  if \code{bwtype} is set to \code{fixed}, an object containing
  bandwidths, of class \code{bandwidth}
  (or scale factors if \code{bwscaling = TRUE}) is returned. If it is set to
  \code{generalized_nn} or \code{adaptive_nn}, then instead the
  \eqn{k}th nearest 
  neighbors are returned for the continuous variables while the discrete
  kernel bandwidths are returned for the discrete variables. Bandwidths
  are stored under the component name \code{bw}, with each
  element \eqn{i} corresponding to column \eqn{i} of input data
  \code{dat}.

  The functions  \code{\link{predict}}, \code{\link{summary}} and \code{\link{plot}} support
  objects of type \code{bandwidth}.
}
\references{

  Aitchison, J. and C.G.G. Aitken (1976), \dQuote{Multivariate binary
    discrimination by the kernel method,} Biometrika, 63, 413-420.

  Bowman, A. and P. Hall and T. Prvan (1998), \dQuote{Bandwidth
    selection for the smoothing of distribution functions,} Biometrika,
    85, 799-808.

  Li, Q. and J.S. Racine (2007), \emph{Nonparametric Econometrics: Theory
  and Practice,} Princeton University Press.

  Li, Q. and J.S. Racine (2003), \dQuote{Nonparametric estimation of
   distributions with categorical and continuous data,} Journal
  of Multivariate Analysis, 86, 266-292.

  Li, C. and H. Li and J.S. Racine (2017), \dQuote{Cross-Validated Mixed
  Datatype Bandwidth Selection for Nonparametric Cumulative
  Distribution/Survivor Functions,} Econometric Reviews, \bold{36},
  970-987.

  Ouyang, D. and Q. Li and J.S. Racine (2006), \dQuote{Cross-validation
    and the estimation of probability distributions with categorical
    data,} Journal of Nonparametric Statistics, 18, 69-100.

  Pagan, A. and A. Ullah (1999), \emph{Nonparametric Econometrics,}
  Cambridge University Press.

  Scott, D.W. (1992), \emph{Multivariate Cumulative Distribution
  Estimation: Theory, Practice and Visualization,} New York: Wiley.

  Silverman, B.W. (1986), \emph{Density Estimation,} London: Chapman and
  Hall.

  Wang, M.C. and J. van Ryzin (1981), \dQuote{A class of smooth estimators
   for discrete distributions,}  Biometrika, 68, 301-309.

}
\author{
    Tristen Hayfield \email{tristen.hayfield@gmail.com}, Jeffrey S. Racine
    \email{racinej@mcmaster.ca}
}

\section{Usage Issues}{
  If you are using data of mixed types, then it is advisable to use the
  \code{\link{data.frame}} function to construct your input data and not
  \code{\link{cbind}}, since \code{\link{cbind}} will typically not work as
  intended on mixed data types and will coerce the data to the same
  type.

  Caution: multivariate data-driven bandwidth selection methods are, by
  their nature, \emph{computationally intensive}. Virtually all methods
  require dropping the \eqn{i}th observation from the data set, computing an
  object, repeating this for all observations in the sample, then
  averaging each of these leave-one-out estimates for a \emph{given}
  value of the bandwidth vector, and only then repeating this a large
  number of times in order to conduct multivariate numerical
  minimization/maximization. Furthermore, due to the potential for local
  minima/maxima, \emph{restarting this procedure a large number of times may
  often be necessary}. This can be frustrating for users possessing
  large datasets. For exploratory purposes, you may wish to override the
  default search tolerances, say, setting ftol=.01 and tol=.01 and
  conduct multistarting (the default is to restart min(5, ncol(dat))
  times) as is done for a number of examples. Once the procedure
  terminates, you can restart search with default tolerances using those
  bandwidths obtained from the less rigorous search (i.e., set
  \code{bws=bw} on subsequent calls to this routine where \code{bw} is
  the initial bandwidth object).  A version of this package using the
  \code{Rmpi} wrapper is under development that allows one to deploy
  this software in a clustered computing environment to facilitate
  computation involving large datasets.
 
}

\seealso{
  \code{\link{bw.nrd}}, \code{\link{bw.SJ}},  \code{\link{hist}},
  \code{\link{npudist}}, \code{\link{npudist}} }
\examples{
\dontrun{
# EXAMPLE 1 (INTERFACE=FORMULA): For this example, we load Giovanni
# Baiocchi's Italian GDP panel (see Italy for details), then create a
# data frame in which year is an ordered factor, GDP is continuous.

data("Italy")
attach(Italy)

data <- data.frame(ordered(year), gdp)

# We compute bandwidths for the kernel cumulative distribution estimator
# using the normal-reference rule-of-thumb. Otherwise, we use the
# defaults (second order Gaussian kernel, fixed bandwidths). Note that
# the bandwidth object you compute inherits all properties of the
# estimator (kernel type, kernel order, estimation method) and can be
# fed directly into the plotting utility plot() or into the npudist()
# function.

bw <- npudistbw(formula=~ordered(year)+gdp, bwmethod="normal-reference")

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, specify a value for the bandwidths manually (0.5 for the first
# variable, 1.0 for the second)...

bw <- npudistbw(formula=~ordered(year)+gdp, bws=c(0.5, 1.0),
                bandwidth.compute=FALSE)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, if you wanted to use the 1.587 sigma n^{-1/(2p+q)} rule-of-thumb
# for the bandwidth for the continuous variable and, say, no smoothing
# for the discrete variable, you would use the bwscaling=TRUE argument
# and feed in the values 0 for the first variable (year) and 1.587 for
# the second (gdp). Note that in the printout it reports the `scale
# factors' rather than the `bandwidth' as reported in some of the
# previous examples.

bw <- npudistbw(formula=~ordered(year)+gdp, bws=c(0, 1.587),
                bwscaling=TRUE, 
                bandwidth.compute=FALSE)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# If you wished to use, say, an eighth-order Epanechnikov kernel for the
# continuous variables and specify your own bandwidths, you could do
# that as follows.

bw <- npudistbw(formula=~ordered(year)+gdp, bws=c(0.5, 1.0),
                bandwidth.compute=FALSE, 
                ckertype="epanechnikov",
                ckerorder=8)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# If you preferred, say, nearest-neighbor bandwidths and a generalized
# kernel estimator for the continuous variable, you would use the
# bwtype="generalized_nn" argument.

bw <- npudistbw(formula=~ordered(year)+gdp, bwtype = "generalized_nn")

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, compute bandwidths using cross-validation, fixed bandwidths, and
# a second-order Gaussian kernel for the continuous variable (default).
# Note - this may take a few minutes depending on the speed of your
# computer.

bw <- npudistbw(formula=~ordered(year)+gdp)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Finally, if you wish to use initial values for numerical search, you
# can either provide a vector of bandwidths as in bws=c(...) or a
# bandwidth object from a previous run, as in

bw <- npudistbw(formula=~ordered(year)+gdp, bws=c(1, 1))

summary(bw)

detach(Italy)

# EXAMPLE 1 (INTERFACE=DATA FRAME): For this example, we load Giovanni
# Baiocchi's Italian GDP panel (see Italy for details), then create a
# data frame in which year is an ordered factor, GDP is continuous.

data("Italy")
attach(Italy)

data <- data.frame(ordered(year), gdp)

# We compute bandwidths for the kernel cumulative distribution estimator
# using the normal-reference rule-of-thumb. Otherwise, we use the
# defaults (second-order Gaussian kernel, fixed bandwidths). Note that
# the bandwidth object you compute inherits all properties of the
# estimator (kernel type, kernel order, estimation method) and can be
# fed directly into the plotting utility plot() or into the npudist()
# function.

bw <- npudistbw(dat=data, bwmethod="normal-reference")

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, specify a value for the bandwidths manually (0.5 for the first
# variable, 1.0 for the second)...

bw <- npudistbw(dat=data, bws=c(0.5, 1.0), bandwidth.compute=FALSE)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, if you wanted to use the 1.587 sigma n^{-1/(2p+q)} rule-of-thumb
# for the bandwidth for the continuous variable and, say, no smoothing
# for the discrete variable, you would use the bwscaling=TRUE argument
# and feed in the values 0 for the first variable (year) and 1.587 for
# the second (gdp). Note that in the printout it reports the `scale
# factors' rather than the `bandwidth' as reported in some of the
# previous examples.

bw <- npudistbw(dat=data, bws=c(0, 1.587),
                bwscaling=TRUE, 
                bandwidth.compute=FALSE)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# If you wished to use, say, an eighth-order Epanechnikov kernel for the
# continuous variables and specify your own bandwidths, you could do
# that as follows:

bw <- npudistbw(dat=data, bws=c(0.5, 1.0),
                bandwidth.compute=FALSE, 
                ckertype="epanechnikov",
                ckerorder=8)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# If you preferred, say, nearest-neighbor bandwidths and a generalized
# kernel estimator for the continuous variable, you would use the
# bwtype="generalized_nn" argument.

bw <- npudistbw(dat=data, bwtype = "generalized_nn")

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Next, compute bandwidths using cross-validation, fixed bandwidths, and
# a second order Gaussian kernel for the continuous variable (default).
# Note - this may take a few minutes depending on the speed of your
# computer.

bw <- npudistbw(dat=data)

summary(bw)

# Sleep for 5 seconds so that we can examine the output...

Sys.sleep(5)

# Finally, if you wish to use initial values for numerical search, you
# can either provide a vector of bandwidths as in bws=c(...) or a
# bandwidth object from a previous run, as in

bw <- npudistbw(dat=data, bws=c(1, 1))

summary(bw)

detach(Italy)
} % enddontrun
}
\keyword{nonparametric}
