## install devtools
install.packages("devtools")

## install Pandoc
# Set the URL for the Pandoc release on Github
url <- "https://github.com/jgm/pandoc/releases/download/2.14.0.1/pandoc-2.14.0.1-windows-x86_64.zip"
# Set the file name for the downloaded file
file_name <- "pandoc-2.14.0.1-windows-x86_64.zip"
# Download the file
download.file(url, destfile = file_name, mode = "wb")
# Extract the contents of the zip file to a local directory
unzip(file_name, exdir = "C:/path/to/local/directory")
# Add the path to the Pandoc executable to the system PATH
pandoc_path <- "C:/path/to/local/directory/pandoc-2.14.0.1-windows-x86_64"
Sys.setenv(PATH = paste(pandoc_path, Sys.getenv("PATH"), sep = ";"))
#check if it was installed correctly
rmarkdown::find_pandoc()

## install TinyTex
tinytex::install_tinytex()
# check for missing packages
tinytex::parse_install()
