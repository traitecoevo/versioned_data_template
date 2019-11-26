# unpack.R 

unpack <- function(read_function, filename) {
  out <- tryCatch(
    {
      read_function(filename)
      3L
    }, 
    error = function(e) {
      message(paste0("Loading ", filename, " failed."))
      message("Check that your unpack function can be applied to the respective file")
      message(e)
      return(1L)
    }, 
    warning = function(w) {
      message(paste0("Loading ", filename, " produced some warnings.")) 
      message(w)
      return(2L)
    }, 
    finally = {
      # message(paste0("opening ", filename, " succeeded"))
    }
  )
}