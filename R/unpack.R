# unpack.R 

unpack <- function(read_function, filename) {
  out <- tryCatch(
    {
      read_function(filename)
      1
    }, 
    error = function(e) {
      message(paste0("Loading ", filename, " failed."))
      message("Check that your unpack function can be applied to the respective file")
      message(e)
      return(NA)
    }, 
    warning = function(w) {
      message(paste0("Loading ", filename, " produced some warnings.")) 
      message(w)
      return(NULL)
    }, 
    finally = {
      # message(paste0("opening ", filename, " succeeded"))
    }
  )
}