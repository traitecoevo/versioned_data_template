## Getting set up to distribute a versioned dataset

This set of instructions relies on a basic knowledge of git and github.  If you're a bit rusty on this see link

### Setting up your pacakge

- Fork the `versioned_data_template` repository
- Rename your repository to reflect your dataset; this name should be the same as the R packages that will destribute your data so something short, precise, and memorable is preferred
- Add your data to the repository, preferably as a csv file (there is also a way to do this without adding your data see somewhere)
- Install the R library devtools if you don't have it already
- Open the dataset_access.R file
- Rename the main function called dataset_access_function to something specific to your dataset 
- In the dataset_info function, change 1) the name of the repository to your repository name 2) the name of the file to reflect the name of the file that contains your dataset.  For small to medium sized datasets we recommend using a csv.  
- Modify the description file to reflect the title, authors, and date for your package (see Hadley's website for more details)
 
### Documenting things for your users (this all builds on ROxygen2 see Hadley for more info):

-  include a description of the dataset in the documentation section of that will show up as the R help file for users once they download and install your package
- you may want to add an example in the help section to show people the important features of your dataset. 
-  In the `dataset_info` function, If your dataset is too complicated to fit into a csv file, you will have to write an input function that loads your data into R.  Replace read_csv with a call to your input function so that your dataset reads nicely into R for your users.  
-  Include the meta-data for your dataset.  Depending on how complicated this is, this may require adding a zip file to the repository with the appropriate meta-data

### Building your documentation and testing your package

- In R, set in the appropriate working directory, call `devtools::document()` 
- Install your package locally `devtools::

### Upload to the cloud

- Commit and push your changes to github
- Update the `DESCRIPTION` file to version 0.0.1
- run `<your_package_name>:::dataset_release("<description>")`

Where `<description>` is a description of what changed in the package



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
