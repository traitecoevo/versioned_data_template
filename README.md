## Setting up dataset versioning

This set of instructions relies on a basic knowledge of git and github.  If you're a bit rusty on this see [here for a general introduction](http://environmentalcomputing.net/version-control/).  This tutorial frequently uses tools on setting up R projects.  For a excellent and general introduction to R packages see [Hadley Wickham's R package website or book](http://r-pkgs.had.co.nz/).  

The rationale for this particular way of setting things up is laid out in [this paper]().  But the 

### Setting up your new and awesome versioned data pacakge

1. Fork the `versioned_data_template` repository
2. Rename your repository to reflect your dataset; this name should be the same as the R packages that will destribute your data so something short, precise, and memorable is preferred
3. Add your data to the repository folder, preferably as a csv file (the data may be but does not have to be pushed to the cloud)
4. Install the R library devtools if you don't have it already
5. In the `dataset_access.R` file, rename the main function called `dataset_access_function` to something specific to your dataset 
6. Also in the `dataset_access.R` file, find the `dataset_info` function and change 1) the name of the repository to your repository name 2) the name of the file to reflect the name of the file that contains your dataset.  
7. **Option for complex data structures:** If your dataset is too complicated to fit into a `csv` file, you will have to write an input function that loads your data into R.  Write this input function, include it in the `dataset_access.R` and replace `read_csv` with a call to your input function so that your dataset reads nicely into R for your users.  
8. Modify the description file to reflect the title, authors, and date for your package (see [here for more details about some of the strange formatting in description files](http://r-pkgs.had.co.nz/description.html))
 
### Documentation for your users (we have set up this template using [roxygen2](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html) for ease of use):

1.  include a description of the dataset in the documentation section of that will show up as the R help file for users once they download and install your package
2. you may want to add an example in the help section to show users how to use the important features of your dataset. 
3.  Include the meta-data for your dataset.  Depending on how complicated this is, this may require adding a zip file to the release with the appropriate meta-data

### Building your documentation and loading your package

1. In R, with the appropriate working directory set, call `devtools::document()` 
2. Install your package locally `devtools::load_all()`

### Upload to the cloud

1. Commit and push your changes to github
2. Update the `DESCRIPTION` file to version 0.0.1
3. On your local machine run `<your_package_name>:::dataset_release("<description>")`  Where `<description>` is a description of what changed in the package

### Testing your package

1. Test that it works by calling the function you created in step (5) of the first section

### Setting up Digital Object Identifier (DOI) assignment

The specifics of this depend on which DOI minter you use.  We have used both zenodo and figshare.  Each source has their own short tutorials for setting this up.  see here or here.  

**That's it.  You now have a package that is set up for versioned data.**

## Managing interactions with users of your database

We recommend suggesting that users flag issues using the "issue tracker" functionality of Github.  This will allow specific questions to be asked, discussed, and resolved.  *Note: if you find an issue with this tutorial, please raise an issue on this repository!*  In some cases these queries may lead to improvements of the underlying dataset, in that case, it makes sense to release a new version of the database.  

## Maintaining a versioned dataset 

When your dataset improves via error fixes or data addition, and you're happy with the changes, there are a few simple steps to bump the dataset into the future.    

1. Update the `DESCRIPTION` file to **increase** the version number.   [Semantic versioning](http://semver.org/) is one way to manage these changes
2.  Update your data with all your improvements
3.  Commit data and code changes and `DESCRIPTION` and push to GitHub
4.  With R in the package directory, run
```r
<your_package_name>:::dataset_release("<description>")
```
where `"<description>"` is a brief description of new features of the release.
