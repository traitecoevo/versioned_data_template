
##' This function provides access to the baadclimate versioned dataset
##'
##'
##' @title Baadclimate Access 
##'
##' @param version Version number.  The default will load the most
##'   recent version on your computer or the most recent version known
##'   to the package if you have never downloaded the data before.
##'   With \code{plant_lookup_del}, specifying \code{version=NULL}
##'   will delete \emph{all} data sets.
##'
##' @param path Path to store the data at.  If not given,
##'   \code{datastorr} will use \code{rappdirs} to find the best place
##'   to put persistent application data on your system.  You can
##'   delete the persistent data at any time by running
##'   \code{mydata_del(NULL)} (or \code{mydata_del(NULL, path)} if you
##'   use a different path).
##'
##' @export
##' @examples
##' #
##' # see the format of the resource
##' #
##' #
##' #

baadclimate_access_function <- function(version=NULL, path=NULL) {
  dataset_get(version, path)
}

## This one is the important part; it defines the three core bits of
## information we need;
##   1. the repository name (traitecoevo/taxonlookup)
##   2. the file to download (plant_lookup.csv)
##   3. the function to read the file, given a filename (read_csv)
dataset_info <- function(path) {
  datastorr::github_release_info_multi("FabriceSamonte/datastorrtest",
                                 filenames=c("baad_with_map.csv", "sdat_10023_1_20190603_003205838.tif"),
                                 read=c(read_csv, read_tif),
                                 path=path)
}

versioned_dataset_info <- function(version = NULL, path) {
  package_info <- dataset_info(path)
  
  if(is.null(version)) {
    ## gets latest remote version if no local version exists,
    ## otherwise it fetches latest local version 
    version <- generate_version(path)
  } 
  ## TODO : If requested version is ahead of package version
  if(version < get_desc_version()) {
    version_metadata <- lookaside_table[lookaside_table$version == version ,]
    package_info$filenames <- c(unique(version_metadata$filename))
    package_info$read <- package_info$filenames %>% 
      lapply(function(x) { eval(parse(text = version_metadata[version_metadata$filename == x ,]$unpack_function)) } )
  } 
  package_info
}

dataset_get <- function(version=NULL, path=NULL) {
  datastorr::github_release_get(versioned_dataset_info(version, path), version)
}

##' @export
##' @rdname fungal_traits
##' @param local Logical indicating if local or github versions should
##'   be polled.  With any luck, \code{local=FALSE} is a superset of
##'   \code{local=TRUE}.  For \code{mydata_version_current}, if
##'   \code{TRUE}, but there are no local versions, then we do check
##'   for the most recent github version.
dataset_versions <- function(local=TRUE, path=NULL) {
  datastorr::github_release_versions(dataset_info(path), local)
}

##' @export
##' @rdname fungal_traits
dataset_version_current <- function(local=TRUE, path=NULL) {
  datastorr::github_release_version_current(dataset_info(path), local)
}

##' @export
##' @rdname fungal_traits
dataset_del <- function(version, path=NULL) {
  if(is.null(version)) {
    package_info <- dataset_info(path)
  } else {
    package_info <- versioned_dataset_info(version, path)
  }
  datastorr::github_release_del(package_info, version)
}

read_csv <- function(...) {
  read.csv(..., stringsAsFactors=FALSE)
}

read_tif <- function(...) {
  raster::raster(...) %>% 
    raster::as.data.frame(xy=TRUE) %>% 
    tibble::as_tibble()
}

read_xl <- function(...) {
  readxl::read_xls(...)
}

update_lookaside_table <- function(path=NULL) {
  package_info <- dataset_info(path)
  
  # version check 
  # prevents double entries 
  local_version <- get_desc_version()
  if(local_version %in% dataset_versions(local=FALSE)) 
    stop(paste0("Version ", local_version, " already exists. Update version field in DESCRIPTION before calling."))
  
  # file and function assertions 
  for(read_function in package_info$read) {
    datastorr::assert_function(read_function)
  }
  for(filename in package_info$filenames) {
    datastorr::assert_file(filename)
  }

  # apply functions 
  # TODO: return values unpack need to be gracefully handled
  message("Test: loading data into R environment")
  for(index in 1:length(package_info$filenames)) {
    unpack(package_info$read[[index]], package_info$filenames[index])
  }
 
  # update table
  # stored internally via usethis::use_data()
  if(!exists("lookaside_table")) {
    lookaside_table <- tibble::tibble(version = character(),
                              filename = character(),
                              unpack_function = character())
  } else if(exists("lookaside_table")) { 
    # clean/reset entries to deal avoid repetition
    message("here")
    lookaside_table <- lookaside_table[lookaside_table$version %in% dataset_versions(local=FALSE) ,]
  }
  
  for(index in 1:length(package_info$filenames)) {
    lookaside_table <- append_lookaside_entry(lookaside_table, local_version, 
                                              package_info$filename[index], package_info$read[[index]])
  }
  usethis::use_data(lookaside_table, internal=TRUE, overwrite=TRUE)
}

dataset_release <- function(description, path=NULL, ...) {
  datastorr::github_release_create(dataset_info(path),
                                   description=description, ...)
}

