\name{npregiv}
\alias{npregiv}

\title{
Nonparametric Instrumental Regression
}
\description{
\code{npregiv} computes nonparametric estimation of an instrumental
regression function \eqn{\varphi}{phi} defined by conditional moment
restrictions stemming from a structural econometric model: \eqn{E [Y -
\varphi (Z,X) | W ] = 0}{E [Y - phi (Z,X) | W ] = 0}, and involving
endogenous variables \eqn{Y} and \eqn{Z} and exogenous variables
\eqn{X} and instruments \eqn{W}. The function \eqn{\varphi}{phi} is the
solution of an ill-posed inverse problem.

When \code{method="Tikhonov"}, \code{npregiv} uses the approach of
Darolles, Fan, Florens and Renault (2011) modified for local
polynomial kernel regression of any order (Darolles et al use local
constant kernel weighting which corresponds to setting \code{p=0}; see
below for details). When \code{method="Landweber-Fridman"},
\code{npregiv} uses the approach of Horowitz (2011) again using local
polynomial kernel regression (Horowitz uses B-spline weighting).
}
\usage{
npregiv(y,
        z,
        w,
        x = NULL,
        zeval = NULL,
        xeval = NULL,
        p = 1,
        nmulti = 1,
        random.seed = 42,
        optim.maxattempts = 10,
        optim.method = c("Nelder-Mead", "BFGS", "CG"),
        optim.reltol = sqrt(.Machine$double.eps),
        optim.abstol = .Machine$double.eps,
        optim.maxit = 500,
        alpha = NULL,
        alpha.iter = NULL,
        alpha.min = 1e-10,
        alpha.max = 1e-01,
        alpha.tol = .Machine$double.eps^0.25,
        iterate.Tikhonov = TRUE,
        iterate.Tikhonov.num = 1,
        iterate.max = 1000,
        iterate.diff.tol = 1.0e-08,
        constant = 0.5,
        method = c("Landweber-Fridman","Tikhonov"),
        penalize.iteration = TRUE,
        smooth.residuals = TRUE,        
        start.from = c("Eyz","EEywz"),
        starting.values  = NULL,
        stop.on.increase = TRUE,
        return.weights.phi = FALSE,
        return.weights.phi.deriv.1 = FALSE,
        return.weights.phi.deriv.2 = FALSE,
        bw = NULL,
        \dots)
}
\arguments{
  \item{y}{
    a one (1) dimensional numeric or integer vector of dependent data, each
    element \eqn{i} corresponding to each observation (row) \eqn{i} of
    \code{z}.
  }

  \item{z}{
    a \eqn{p}-variate data frame of endogenous regressors. The data
    types may be continuous, discrete (unordered and ordered factors),
    or some combination thereof.
  }
  \item{w}{
    a \eqn{q}-variate data frame of instruments. The data types may be
    continuous, discrete (unordered and ordered factors), or some
    combination thereof.
  }
  \item{x}{
    an \eqn{r}-variate data frame of exogenous regressors. The data
    types may be continuous, discrete (unordered and ordered factors),
    or some combination thereof.
  }
  \item{zeval}{
    a \eqn{p}-variate data frame of endogenous regressors on which the
    regression will be estimated (evaluation data). By default, evaluation
    takes place on the data provided by \code{z}.
  }
  \item{xeval}{
    an \eqn{r}-variate data frame of exogenous regressors on which the
    regression will be estimated (evaluation data). By default,
    evaluation takes place on the data provided by \code{x}.
  }
  \item{p}{
    the order of the local polynomial regression (defaults to
    \code{p=1}, i.e. local linear).
  }
  \item{nmulti}{
    integer number of times to restart the process of finding extrema of
    the cross-validation function from different (random) initial
    points.
  }

  \item{random.seed}{
    an integer used to seed R's random number generator. This ensures
    replicability of the numerical search. Defaults to 42.
  }

  \item{optim.method}{ method used by \code{\link{optim}} for minimization of
    the objective function. See \code{?optim} for references. Defaults
    to \code{"Nelder-Mead"}.

    the default method is an implementation of that of Nelder and Mead
    (1965), that uses only function values and is robust but relatively
    slow.  It will work reasonably well for non-differentiable
    functions.

    method \code{"BFGS"} is a quasi-Newton method (also known as a
    variable metric algorithm), specifically that published
    simultaneously in 1970 by Broyden, Fletcher, Goldfarb and Shanno.
    This uses function values and gradients to build up a picture of the
    surface to be optimized.

    method \code{"CG"} is a conjugate gradients method based
    on that by Fletcher and Reeves (1964) (but with the option of
    Polak-Ribiere or Beale-Sorenson updates).  Conjugate gradient
    methods will generally be more fragile than the BFGS method, but as
    they do not store a matrix they may be successful in much larger
    optimization problems.
  }

  \item{optim.maxattempts}{
    maximum number of attempts taken trying to achieve successful
    convergence in \code{\link{optim}}. Defaults to \code{100}.
  }

  \item{optim.abstol}{
    the absolute convergence tolerance used by \code{\link{optim}}. Only useful
    for non-negative functions, as a tolerance for reaching
    zero. Defaults to \code{.Machine$double.eps}.
  }

  \item{optim.reltol}{
    relative convergence tolerance used by \code{\link{optim}}.  The algorithm
    stops if it is unable to reduce the value by a factor of 'reltol *
    (abs(val) + reltol)' at a step.  Defaults to
    \code{sqrt(.Machine$double.eps)}, typically about \code{1e-8}.
  }

  \item{optim.maxit}{
    maximum number of iterations used by \code{\link{optim}}. Defaults
     to \code{500}.
   }
  \item{alpha}{
    a numeric scalar that, if supplied, is used rather than numerically
    solving for \code{alpha}, when using \code{method="Tikhonov"}.
    }
  \item{alpha.iter}{
    a numeric scalar that, if supplied, is used for iterated Tikhonov
    rather than numerically solving for \code{alpha}, when using
    \code{method="Tikhonov"}.
  }
  \item{alpha.min}{
    minimum of search range for \eqn{\alpha}{alpha}, the Tikhonov
    regularization parameter, when using \code{method="Tikhonov"}.
  }
  \item{alpha.max}{
    maximum of search range for \eqn{\alpha}{alpha}, the Tikhonov
    regularization parameter, when using  \code{method="Tikhonov"}.
  }
  \item{alpha.tol}{
    the search tolerance for \code{optimize} when solving for
    \eqn{\alpha}{alpha}, the Tikhonov regularization parameter,
    when using \code{method="Tikhonov"}.
  }
  \item{iterate.Tikhonov}{
    a logical value indicating whether to use iterated Tikhonov (one
    iteration) or not when using \code{method="Tikhonov"}.
  }
  \item{iterate.Tikhonov.num}{
    an integer indicating the number of iterations to conduct when using
    \code{method="Tikhonov"}.
  }
  \item{iterate.max}{
    an integer indicating the maximum number of iterations permitted
    before termination occurs when using \code{method="Landweber-Fridman"}.
  }
  \item{iterate.diff.tol}{
    the search tolerance for the difference in the stopping rule from
    iteration to iteration when using \code{method="Landweber-Fridman"}
    (disable by setting to zero).
  }
  \item{constant}{
    the constant to use when using  \code{method="Landweber-Fridman"}.
  }
  \item{method}{
    the regularization method employed (defaults to
    \code{"Landweber-Fridman"}, see Horowitz (2011); see Darolles,
    Fan, Florens and Renault (2011) for details for
    \code{"Tikhonov"}).
  }
  \item{penalize.iteration}{ a logical value indicating whether to
    penalize the norm by the number of iterations or not (default
    \code{TRUE})
  }    
  \item{smooth.residuals}{ a logical value indicating whether to
    optimize bandwidths for the regression of
    \eqn{(y-\varphi(z))}{(y-phi(z))} on \eqn{w} (defaults to
    \code{TRUE}) or for the regression of \eqn{\varphi(z)}{phi(z)} on
    \eqn{w} during iteration
  }
  \item{start.from}{ a character string indicating whether to start from
    \eqn{E(Y|z)} (default, \code{"Eyz"}) or from \eqn{E(E(Y|z)|z)} (this can
    be overridden by providing \code{starting.values} below)
  }  
  \item{starting.values}{ a value indicating whether to commence
    Landweber-Fridman assuming
    \eqn{\varphi_{-1}=starting.values}{phi[-1]=starting.values} (proper
    Landweber-Fridman) or instead begin from \eqn{E(y|z)} (defaults to
    \code{NULL}, see details below)
  }
  \item{stop.on.increase}{
    a logical value (defaults to \code{TRUE}) indicating whether to halt
    iteration if the stopping criterion (see below) increases over the
    course of one iteration (i.e. it may be above the iteration tolerance
    but increased)
  }
  \item{return.weights.phi}{
    a logical value (defaults to \code{FALSE}) indicating whether to
    return the weight matrix which when postmultiplied by the response
    \eqn{y} delivers the instrumental regression
  }
  \item{return.weights.phi.deriv.1}{
    a logical value (defaults to \code{FALSE}) indicating whether to
    return the weight matrix which when postmultiplied by the response
    \eqn{y} delivers the first partial derivative of the instrumental
    regression with respect to \eqn{z}
  }
  \item{return.weights.phi.deriv.2}{
    a logical value (defaults to \code{FALSE}) indicating whether to
    return the weight matrix which when postmultiplied by the response
    \eqn{y} delivers the second partial derivative of the instrumental
    regression with respect to \eqn{z}
  }
  \item{bw}{
    an object which, if provided, contains bandwidths and parameters
    (obtained from a previous invocation of \code{npregiv}) required to
    re-compute the estimator without having to re-run cross-validation
    and/or numerical optimization which is particularly costly in this
    setting (see details below for an illustration of its use)
  }
  \item{\dots}{
    additional arguments supplied to \code{\link{npksum}}.
  }
}
\details{
  Tikhonov regularization requires computation of weight matrices of
  dimension \eqn{n\times n}{n x n} which can be computationally costly
  in terms of memory requirements and may be unsuitable for large
  datasets. Landweber-Fridman will be preferred in such settings as it
  does not require construction and storage of these weight matrices
  while it also avoids the need for numerical optimization methods to
  determine \eqn{\alpha}{alpha}.
  
  \code{method="Landweber-Fridman"} uses an optimal stopping rule based
  upon \eqn{||E(y|w)-E(\varphi_k(z,x)|w)||^2
  }{||E(y|w)-E(phi(z,x)|w)||^2 }. However, if insufficient training is
  conducted the estimates can be overly noisy. To best guard against
  this eventuality set \code{nmulti} to a larger number than the default
  \code{nmulti=1} for \code{\link{npreg}}.

  When using \code{method="Landweber-Fridman"}, iteration will terminate
  when either the change in the value of
  \eqn{||(E(y|w)-E(\varphi_k(z,x)|w))/E(y|w)||^2
  }{||(E(y|w)-E(phi(z,x)|w))/E(y|w)||^2 } from iteration to iteration is
  less than \code{iterate.diff.tol} or we hit \code{iterate.max} or
  \eqn{||(E(y|w)-E(\varphi_k(z,x)|w))/E(y|w)||^2
  }{||(E(y|w)-E(phi(z,x)|w))/E(y|w)||^2 } stops falling in value and
  starts rising.

  The option \code{bw=} would be useful, say, when bootstrapping is
  necessary. Note that when passing \code{bw}, it must be obtained from
  a previous invocation of \code{npregiv}. For instance, if
  \code{model.iv} was obtained from an invocation of \code{npregiv} with
  \code{method="Landweber-Fridman"}, then the following needs to be fed
  to the subsequent invocation of \code{npregiv}:

  \preformatted{

    model.iv <- npregiv(\dots)

    bw <- NULL
    bw$bw.E.y.w <- model.iv$bw.E.y.w
    bw$bw.E.y.z <- model.iv$bw.E.y.z
    bw$bw.resid.w <- model.iv$bw.resid.w
    bw$bw.resid.fitted.w.z <- model.iv$bw.resid.fitted.w.z
    bw$norm.index <- model.iv$norm.index

    foo <- npregiv(\dots,bw=bw)
  }

  If, on the other hand \code{model.iv} was obtained from an invocation
  of \code{npregiv} with \code{method="Tikhonov"}, then the following
  needs to be fed to the subsequent invocation of \code{npregiv}:

  \preformatted{

    model.iv <- npregiv(\dots)

    bw <- NULL
    bw$alpha <- model.iv$alpha
    bw$alpha.iter <- model.iv$alpha.iter
    bw$bw.E.y.w <- model.iv$bw.E.y.w
    bw$bw.E.E.y.w.z <- model.iv$bw.E.E.y.w.z
    bw$bw.E.phi.w <- model.iv$bw.E.phi.w
    bw$bw.E.E.phi.w.z <- model.iv$bw.E.E.phi.w.z

    foo <- npregiv(\dots,bw=bw)    

  }

  Or, if \code{model.iv} was obtained from an invocation of
  \code{npregiv} with either \code{method="Landweber-Fridman"} or
  \code{method="Tikhonov"}, then the following would also work:

  \preformatted{

    model.iv <- npregiv(\dots)

    foo <- npregiv(\dots,bw=model.iv)    

  }

  
  When exogenous predictors \code{x} (\code{xeval}) are passed, they are
  appended to both the endogenous predictors \code{z} and the
  instruments \code{w} as additional columns. If this is not desired,
  one can manually append the exogenous variables to \code{z} (or
  \code{w}) prior to passing \code{z} (or \code{w}), and then they will
  only appear among the \code{z} or \code{w} as desired.
  
}

\value{

  \code{npregiv} returns a list with components \code{phi},
  \code{phi.mat} and either \code{alpha} when \code{method="Tikhonov"}
  or \code{norm.index}, \code{norm.stop} and \code{convergence} when
  \code{method="Landweber-Fridman"}, among others.

  In addition, if any of \code{return.weights.*} are invoked
  (\code{*=1,2}), then \code{phi.weights} and \code{phi.deriv.*.weights}
  return weight matrices for computing the instrumental regression and
  its partial derivatives. Note that these weights, post multiplied by
  the response vector \eqn{y}, will deliver the estimates returned in
  \code{phi}, \code{phi.deriv.1}, and \code{phi.deriv.2} (the latter
  only being produced when \code{p} is 2 or greater). When invoked with
  evaluation data, similar matrices are returned but named
  \code{phi.eval.weights} and \code{phi.deriv.eval.*.weights}. These
  weights can be used for constrained estimation, among others.

  When \code{method="Landweber-Fridman"} is invoked, bandwidth objects
  are returned in \code{bw.E.y.w} (scalar/vector), \code{bw.E.y.z}
  (scalar/vector), and \code{bw.resid.w} (matrix) and
  \code{bw.resid.fitted.w.z}, the latter matrices containing bandwidths
  for each iteration stored as rows. When \code{method="Tikhonov"} is
  invoked, bandwidth objects are returned in \code{bw.E.y.w},
  \code{bw.E.E.y.w.z}, and \code{bw.E.phi.w} and \code{bw.E.E.phi.w.z}.
  
}

\references{
  
  Carrasco, M. and J.P. Florens and E. Renault (2007), \dQuote{Linear
  Inverse Problems in Structural Econometrics Estimation Based on
  Spectral Decomposition and Regularization,} In: James J. Heckman and
  Edward E. Leamer, Editor(s), Handbook of Econometrics, Elsevier, 2007,
  Volume 6, Part 2, Chapter 77, Pages 5633-5751

  Darolles, S. and Y. Fan and J.P. Florens and E. Renault (2011),
  \dQuote{Nonparametric instrumental regression,} Econometrica, 79,
  1541-1565.
  
  Feve, F. and J.P. Florens (2010), \dQuote{The practice of
  non-parametric estimation by solving inverse problems: the example of
  transformation models,} Econometrics Journal, 13, S1-S27.

  Florens, J.P. and J.S. Racine and S. Centorrino (forthcoming),
  \dQuote{Nonparametric instrumental derivatives,} Journal of
  Nonparametric Statistics.

  Fridman, V. M. (1956), \dQuote{A method of successive approximations
  for Fredholm integral equations of the first kind,} Uspeskhi,
  Math. Nauk., 11, 233-334, in Russian.

  Horowitz, J.L. (2011), \dQuote{Applied nonparametric instrumental
  variables estimation,} Econometrica, 79, 347-394.
  
  Landweber, L. (1951), \dQuote{An iterative formula for Fredholm
  integral equations of the first kind,} American Journal of
  Mathematics, 73, 615-24.

  Li, Q. and J.S. Racine (2007), \emph{Nonparametric Econometrics:
  Theory and Practice,} Princeton University Press.

  Li, Q. and J.S. Racine (2004), \dQuote{Cross-validated Local Linear
  Nonparametric Regression,} Statistica Sinica, 14, 485-512.

}
\author{
  Jeffrey S. Racine \email{racinej@mcmaster.ca}, Samuele Centorrino
 \email{samuele.centorrino@univ-tlse1.fr}
}
\note{
This function should be considered to be in `beta test' status until further notice.
}

\seealso{
\code{\link{npregivderiv},\link{npreg}}
}
\examples{
\dontrun{
## This illustration was made possible by Samuele Centorrino
## <samuele.centorrino@univ-tlse1.fr>

set.seed(42)
n <- 500

## The DGP is as follows:

## 1) y = phi(z) + u

## 2) E(u|z) != 0 (endogeneity present)

## 3) Suppose there exists an instrument w such that z = f(w) + v and
## E(u|w) = 0

## 4) We generate v, w, and generate u such that u and z are
## correlated. To achieve this we express u as a function of v (i.e. u =
## gamma v + eps)

v <- rnorm(n,mean=0,sd=0.27)
eps <- rnorm(n,mean=0,sd=0.05)
u <- -0.5*v + eps
w <- rnorm(n,mean=0,sd=1)

## In Darolles et al (2011) there exist two DGPs. The first is
## phi(z)=z^2 and the second is phi(z)=exp(-abs(z)) (which is
## discontinuous and has a kink at zero).

fun1 <- function(z) { z^2 }
fun2 <- function(z) { exp(-abs(z)) }

z <- 0.2*w + v

## Generate two y vectors for each function.

y1 <- fun1(z) + u
y2 <- fun2(z) + u

## You set y to be either y1 or y2 (ditto for phi) depending on which
## DGP you are considering:

y <- y1
phi <- fun1

## Sort on z (for plotting)

ivdata <- data.frame(y,z,w)
ivdata <- ivdata[order(ivdata$z),]
rm(y,z,w)
attach(ivdata)

model.iv <- npregiv(y=y,z=z,w=w)
phi.iv <- model.iv$phi

## Now the non-iv local linear estimator of E(y|z)

ll.mean <- fitted(npreg(y~z,regtype="ll"))

## For the plots, restrict focal attention to the bulk of the data
## (i.e. for the plotting area trim out 1/4 of one percent from each
## tail of y and z)

trim <- 0.0025

curve(phi,min(z),max(z),
      xlim=quantile(z,c(trim,1-trim)),
      ylim=quantile(y,c(trim,1-trim)),
      ylab="Y",
      xlab="Z",
      main="Nonparametric Instrumental Kernel Regression",
      lwd=2,lty=1)

points(z,y,type="p",cex=.25,col="grey")

lines(z,phi.iv,col="blue",lwd=2,lty=2)

lines(z,ll.mean,col="red",lwd=2,lty=4)

legend("topright",
       c(expression(paste(varphi(z))),
         expression(paste("Nonparametric ",hat(varphi)(z))),
         "Nonparametric E(y|z)"),
       lty=c(1,2,4),
       col=c("black","blue","red"),
       lwd=c(2,2,2),
       bty="n")
       
} % enddontrun
}
\keyword{ instrument }
