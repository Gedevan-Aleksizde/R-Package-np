\name{npcdist}
\alias{npcdist}
\alias{npcdist.call}
\alias{npcdist.condbandwidth}
\alias{npcdist.default}
\alias{npcdist.formula}

\title{Kernel Conditional Distribution Estimation with Mixed Data Types}

\description{
  \code{npcdist} computes kernel cumulative conditional distribution
  estimates on \eqn{p+q}-variate evaluation data, given a set of
  training data (both explanatory and dependent) and a bandwidth
  specification (a \code{condbandwidth} object or a bandwidth vector,
  bandwidth type, and kernel type) using the method of Li and Racine
  (2008) and Li, Lin, and Racine (2013).  The data may be continuous,
  discrete (unordered and ordered factors), or some combination thereof.
}

\usage{
npcdist(bws, \dots)

\method{npcdist}{formula}(bws, data = NULL, newdata = NULL, \dots)

\method{npcdist}{call}(bws, \dots)

\method{npcdist}{condbandwidth}(bws,
        txdat = stop("invoked without training data 'txdat'"),
        tydat = stop("invoked without training data 'tydat'"),
        exdat,
        eydat,
        gradients = FALSE,
        \dots)

\method{npcdist}{default}(bws, txdat, tydat, \dots)

}

\arguments{
  \item{bws}{
    a bandwidth specification. This can be set as a \code{condbandwidth}
    object returned from a previous invocation of
    \code{\link{npcdistbw}}, or as a \eqn{p+q}-vector of bandwidths,
    with each element \eqn{i} up to \eqn{i=q} corresponding to the
    bandwidth for column \eqn{i} in \code{tydat}, and each element
    \eqn{i} from \eqn{i=q+1} to \eqn{i=p+q} corresponding to the
    bandwidth for column \eqn{i-q} in \code{txdat}. If specified as a
    vector, then additional arguments will need to be supplied as
    necessary to specify the bandwidth type, kernel types, training
    data, and so on.
  }

  \item{gradients}{
    a logical value specifying whether to return estimates of the
    gradients at the evaluation points. Defaults to \code{FALSE}.
  }

  \item{\dots}{
    additional arguments supplied to specify the bandwidth type, kernel
    types, and so on.  This is necessary if you specify bws as a
    \eqn{p+q}-vector and not a \code{condbandwidth} object, and you do
    not desire the default behaviours. To do this, you may specify any
    of \code{bwmethod}, \code{bwscaling}, \code{bwtype},
    \code{cxkertype}, \code{cxkerorder}, \code{cykertype},
    \code{cykerorder}, \code{uxkertype}, \code{oxkertype},
    \code{oykertype}, as described in \code{\link{npcdistbw}}.
  }
  
  \item{data}{
    an optional data frame, list or environment (or object coercible to
    a data frame by \code{\link{as.data.frame}}) containing the
    variables in the model. If not found in data, the variables are
    taken from \code{environment(bws)}, typically the environment from
    which \code{\link{npcdistbw}} was called.
 }

  \item{newdata}{
    An optional data frame in which to look for evaluation data. If
    omitted, the training data are used.  
  }


  \item{txdat}{
    a \eqn{p}-variate data frame of sample realizations of explanatory
    data (training data). Defaults to the training data used to
    compute the bandwidth object.
  }

  \item{tydat}{
    a \eqn{q}-variate data frame of sample realizations of dependent
    data (training data). Defaults to the training data used to
    compute the bandwidth object.
  }

  \item{exdat}{
    a \eqn{p}-variate data frame of explanatory data on
    which cumulative conditional distributions will be evaluated. By
    default, evaluation takes place on the data provided by
    \code{txdat}.
  }

  \item{eydat}{
    a \eqn{q}-variate data frame of dependent data on which
    cumulative conditional distributions will be evaluated. By default,
    evaluation takes place on the data provided by \code{tydat}.
  }

}
\details{
  \code{npcdist} implements a variety of methods for estimating
  multivariate conditional cumulative distributions (\eqn{p+q}-variate)
  defined over a set of possibly continuous and/or discrete (unordered,
  ordered) data. The approach is based on Li and Racine (2004) who
  employ \sQuote{generalized product kernels} that admit a mix of
  continuous and discrete data types.

  Three classes of kernel estimators for the continuous data types are
  available: fixed, adaptive nearest-neighbor, and generalized
  nearest-neighbor. Adaptive nearest-neighbor bandwidths change with
  each sample realization in the set, \eqn{x_i}{x[i]}, when estimating
  the cumulative conditional distribution at the point
  \eqn{x}. Generalized nearest-neighbor bandwidths change with the point
  at which the cumulative conditional distribution is estimated,
  \eqn{x}. Fixed bandwidths are constant over the support of \eqn{x}.

  Training and evaluation input data  may be a
  mix of continuous (default), unordered discrete (to be specified in
  the data frames using \code{\link{factor}}), and ordered discrete (to be
  specified in the data frames using \code{\link{ordered}}). Data can be
  entered in an arbitrary order and data types will be detected
  automatically by the routine (see \code{\link{np}} for details).

  A variety of kernels may be specified by the user. Kernels implemented
  for continuous data types include the second, fourth, sixth, and eighth
  order Gaussian and Epanechnikov kernels, and the uniform
  kernel. Unordered discrete data types use a variation on Aitchison and
  Aitken's (1976) kernel, while ordered data types use a variation of the
  Wang and van Ryzin (1981) kernel.

}
\value{
  \code{npcdist} returns a \code{condistribution} object. The generic
  accessor functions \code{\link{fitted}}, \code{\link{se}}, and
  \code{\link{gradients}}, extract estimated values, asymptotic standard
  errors on estimates, and gradients, respectively, from
  the returned object. Furthermore, the functions \code{\link{predict}},
  \code{\link{summary}}
  and \code{\link{plot}} support objects of both classes. The returned objects
  have the following components:

  \item{xbw}{ bandwidth(s), scale factor(s) or nearest neighbours for the
    explanatory data, \code{txdat} }
  \item{ybw}{ bandwidth(s), scale factor(s) or nearest neighbours for the
    dependent data, \code{tydat} }
  \item{xeval}{ the evaluation points of the explanatory data }
  \item{yeval}{ the evaluation points of the dependent data }
  \item{condist}{ estimates of the conditional cumulative
    distribution at the evaluation points }
  \item{conderr}{ standard errors of the cumulative conditional distribution
    estimates }
  \item{congrad}{ if invoked with \code{gradients = TRUE}, estimates of
    the gradients at the evaluation points }
  \item{congerr}{ if invoked with \code{gradients = TRUE}, standard
    errors of the gradients at the evaluation points }
  \item{log_likelihood}{ log likelihood of the cumulative conditional distribution estimate }

}

\references{

  Aitchison, J. and C.G.G. Aitken (1976), \dQuote{Multivariate binary
    discrimination by the kernel method,} Biometrika, 63, 413-420.

  Hall, P. and J.S. Racine and Q. Li (2004), \dQuote{Cross-validation and the
    estimation of conditional probability densities,} Journal of the
  American Statistical Association, 99, 1015-1026.

  Li, Q. and J.S. Racine (2007), \emph{Nonparametric Econometrics: Theory
    and Practice,} Princeton University Press.

  Li, Q. and J.S. Racine (2008), \dQuote{Nonparametric estimation of
  conditional CDF and quantile functions with mixed categorical and
  continuous data,} Journal of Business and Economic Statistics, 26,
  423-434.
  
  Li, Q. and J. Lin and J.S. Racine (2013), \dQuote{Optimal bandwidth
  selection for nonparametric conditional distribution and quantile
  functions}, Journal of Business and Economic Statistics, 31, 57-65.

  Pagan, A. and A. Ullah (1999), \emph{Nonparametric Econometrics,} Cambridge
  University Press. 

  Scott, D.W. (1992), \emph{Multivariate Density Estimation. Theory,
  Practice and Visualization,} New York: Wiley.

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
}

\seealso{
  \code{\link{npudens}}
}
\examples{
\dontrun{
# EXAMPLE 1 (INTERFACE=FORMULA): For this example, we load Giovanni
# Baiocchi's Italian GDP panel (see Italy for details), and compute the
# cross-validated bandwidths (default) using a second-order Gaussian
# kernel (default). Note - this may take a minute or two depending on
# the speed of your computer.

data("Italy")
attach(Italy)

# First, compute the bandwidths.

bw <- npcdistbw(formula=gdp~ordered(year))

# Next, compute the condistribution object...

Fhat <- npcdist(bws=bw)

# The object Fhat now contains results such as the estimated cumulative
# conditional distribution function (Fhat$condist) and so on...

summary(Fhat)

# Call the plot() function to visualize the results (<ctrl>-C will
# interrupt on *NIX systems, <esc> will interrupt on MS Windows
# systems).

plot(bw)

detach(Italy)

# EXAMPLE 1 (INTERFACE=DATA FRAME): For this example, we load Giovanni
# Baiocchi's Italian GDP panel (see Italy for details), and compute the
# cross-validated bandwidths (default) using a second-order Gaussian
# kernel (default). Note - this may take a minute or two depending on
# the speed of your computer.

data("Italy")
attach(Italy)

# First, compute the bandwidths.

# Note - we cast `X' and `y' as data frames so that plot() can
# automatically grab names (this looks like overkill, but in
# multivariate settings you would do this anyway, so may as well get in
# the habit).

X <- data.frame(year=ordered(year))
y <- data.frame(gdp)

bw <- npcdistbw(xdat=X, ydat=y)

# Next, compute the condistribution object...

Fhat <- npcdist(bws=bw)

# The object Fhat now contains results such as the estimated cumulative
# conditional distribution function (Fhat$condist) and so on...

summary(Fhat)

# Call the plot() function to visualize the results (<ctrl>-C will
# interrupt on *NIX systems, <esc> will interrupt on MS Windows systems).

plot(bw)

detach(Italy)

# EXAMPLE 2 (INTERFACE=FORMULA): For this example, we load the old
# faithful geyser data from the R `datasets' library and compute the
# conditional distribution function.

library("datasets")
data("faithful")
attach(faithful)

# Note - this may take a few minutes depending on the speed of your
# computer...

bw <- npcdistbw(formula=eruptions~waiting)

summary(bw)

# Plot the conditional cumulative distribution function (<ctrl>-C will
# interrupt on *NIX systems, <esc> will interrupt on MS Windows
# systems).

plot(bw)

detach(faithful)

# EXAMPLE 2 (INTERFACE=DATA FRAME): For this example, we load the old
# faithful geyser data from the R `datasets' library and compute the
# cumulative conditional distribution function.

library("datasets")
data("faithful")
attach(faithful)

# Note - this may take a few minutes depending on the speed of your
# computer...

# Note - we cast `X' and `y' as data frames so that plot() can
# automatically grab names (this looks like overkill, but in
# multivariate settings you would do this anyway, so may as well get in
# the habit).

X <- data.frame(waiting)
y <- data.frame(eruptions)

bw <- npcdistbw(xdat=X, ydat=y)

summary(bw)

# Plot the conditional cumulative distribution function (<ctrl>-C will
# interrupt on *NIX systems, <esc> will interrupt on MS Windows systems)

plot(bw)

detach(faithful)

} % enddontrun
}
\keyword{nonparametric}

