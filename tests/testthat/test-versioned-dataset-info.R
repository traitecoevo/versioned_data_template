## test-versioned-dataset-info.R 

test_that("Versioned dataset info test", {

  
  path <- tempfile("info-test")
  on.exit(unlink(path, recursive=TRUE))
  
  info <- dataset_info(path)
  
  versioned_info <- versioned_dataset_info(path, "1.0.0", operation="get")
  expect_error(versioned_dataset_info(path, "1.0.1", operation="get"))
  
  expect_is(versioned_info, "github_release_info")
  expect_identical(versioned_info$filenames, c("Globcover_Legend.xls"))
  expect_identical(versioned_info$path, path)
  
  expect_identical(info, versioned_dataset_info(path, NULL, operation="del"))
  expect_equal(versioned_info, versioned_dataset_info(path, "1.0.0", operation="del"))
  expect_identical(info, versioned_dataset_info(path, "2.0.0", operation="del"))
  expect_identical(info, versioned_dataset_info(path, operation="version"))
  
  ## TODO: test cases when running from an old version of a package
  
})