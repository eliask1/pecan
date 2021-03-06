#' @name generate.noise
#' @title Generate autocorrelated spectral noise
#' @param n Length of output vector (default = 2101)
#' @param sigma Gaussian noise standard deviation (default=1e-4)
#' @param fw Filter width. Will be coerced to an odd number if even (default = 201).
#' @param fsd Scaling factor for filter standard deviation (default = 6)
#' @export
generate.noise <- function(n = 2101, sigma = 1e-04, fw = 201, fsd = 6) {
  if (fw%%2 == 0) {
    fw <- fw + 1  # fw must be odd
  }
  f.in <- seq_len(fw)
  f.raw <- dnorm(f.in, median(f.in), fw / fsd)
  f <- f.raw * 1 / max(f.raw)
  x <- stats::filter(rnorm(n, 0, sigma), filter = f, circular = TRUE)
  return(x)
} # generate.noise
