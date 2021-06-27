#' @export
swiper_presentation <- function(
  keep_md = FALSE,
  self_contained = FALSE,
  ...
) {
  rmarkdown::output_format(
    knitr = NULL,
    pandoc = rmarkdown::pandoc_options(
      to = "html5",
      args = c(
        "--include-in-header", swiper_file("header.html"),
        "--include-before-body", swiper_file("before-body.html"),
        "--include-after-body", swiper_file("after-body.html"),
        "--lua-filter", swiper_file("swiper.lua")
      )
    ),
    keep_md = keep_md,
    clean_supporting = !self_contained,
    base_format = rmarkdown::html_vignette(
      template = NULL,
      mathjax = NULL,
      toc = FALSE
    )
  )
}

swiper_file <- function(...) {
  system.file(
    package = "swiper",
    "rmarkdown/templates/swiper_presentation",
    ...
  )
}
