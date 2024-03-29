% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mlp.r
\docType{class}
\name{MLP}
\alias{MLP}
\title{The 'MLP' class object}
\format{
\code{\link{R6Class}} object.
}
\value{
an  \code{\link{R6Class}} object which can be used for the rkhs interpolation.
}
\description{
This a R6 class. It inherits from 'kernel' class. It provides the mlp kernel function and the 1st order derivative of mlp kernel function.
}
\author{
Mu Niu, \email{mu.niu@glasgow.ac.uk}
}
\keyword{data}
\section{Super class}{
\code{\link[KGode:Kernel]{KGode::Kernel}} -> \code{MLP}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-MLP-greet}{\code{MLP$greet()}}
\item \href{#method-MLP-set_k_par}{\code{MLP$set_k_par()}}
\item \href{#method-MLP-kern}{\code{MLP$kern()}}
\item \href{#method-MLP-dkd_kpar}{\code{MLP$dkd_kpar()}}
\item \href{#method-MLP-dkdt}{\code{MLP$dkdt()}}
\item \href{#method-MLP-clone}{\code{MLP$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="KGode" data-topic="Kernel" data-id="initialize"><a href='../../KGode/html/Kernel.html#method-Kernel-initialize'><code>KGode::Kernel$initialize()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-greet"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-greet}{}}}
\subsection{Method \code{greet()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$greet()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-set_k_par"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-set_k_par}{}}}
\subsection{Method \code{set_k_par()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$set_k_par(val)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-kern"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-kern}{}}}
\subsection{Method \code{kern()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$kern(t1, t2)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-dkd_kpar"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-dkd_kpar}{}}}
\subsection{Method \code{dkd_kpar()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$dkd_kpar(t1, t2)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-dkdt"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-dkdt}{}}}
\subsection{Method \code{dkdt()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$dkdt(t1, t2)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MLP-clone"></a>}}
\if{latex}{\out{\hypertarget{method-MLP-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MLP$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
