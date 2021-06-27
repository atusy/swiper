#' @export
swiper_presentation <- function(
  keep_md = FALSE,
  self_contained = FALSE,
  template = NULL,
  ...
) {
  base_format = rmarkdown::html_document(
    keep_md = keep_md,
    self_contained = self_contained,
    template = template,
    theme = NULL,
    mathjax = NULL,
    toc = FALSE, # Not yet implemented
    ...
  )
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
    keep_md = base_format$keep_md,
    clean_supporting = base_format$clean_supporting,
    base_format = base_format
  )
}

swiper_file <- function(...) {
  system.file(
    package = "swiper",
    "rmarkdown/templates/swiper_presentation",
    ...
  )
}
