#' Download a ZIP file, extract, and save the data as an RDS file.
#'
#' This is a utility function that will download a zip file and extract the
#' data.
#'
#' @param url the url of the ZIP file containing the data.
#' @param filename the name of the RDS file to write (excluding file extension).
#' @param download.dir directory to download the ZIP file.
#' @param out.dir directory to write the RDS file.
#' @param filetypes file extensions to look for in the ZIP file to convert to RDS.
#' @param redownload whether to redownload the ZIP file.
#' @param cleanup delete the downloaded ZIP file if the RDS file was created successfully.
#' @return the data object read. This would be a data frame (for CSV files) or
#'         a list (for MDB and AACDB files).
#' @export
downloadAndSaveRDS <- function(url,
							   filename = tools::file_path_sans_ext(basename(url)),
							   download.dir = 'data-raw/',
							   out.dir = 'data/',
							   filetypes = c('mdb', 'aacdb', 'csv'),
							   redownload = FALSE,
							   cleanup = FALSE) {
	f <- basename(url)
	zipfile <- paste0(download.dir, f)
	file.ext <- tolower(tools::file_ext(url))
	extract.dir <- paste0(download.dir, tools::file_path_sans_ext(f))
	out.file <- paste0(out.dir, '/', filename, '.rds')

	if(!file.exists(out.file) | redownload) {
		download.file(url, zipfile, mode = 'wb')
		if(file.ext == 'zip') {
			unzip(zipfile, exdir = extract.dir, overwrite = TRUE)
		}
		df <- NULL

		for(i in filetypes) {
			files <- list.files(extract.dir, pattern = paste0('.', i, '$'))
			if(length(files) > 0) {
				if(length(files) > 1) {
					warning(paste0('More than one data file found, loading ', files[1]))
				}
				if(tolower(i) == 'csv') { # TODO: add other file types (e.g. Excel)
					df <- read.csv(paste0(extract.dir, '/', files[1]),
								   stringsAsFactors = FALSE)
				} else if(tolower(i) %in% c('mdb', 'aacdb')) {
					df <- Hmisc::mdb.get(paste0(extract.dir, '/', files[1]),
										 stringsAsFactors = FALSE,
										 autodates = FALSE)
				} else {
					stop(paste0('Unknown file type: ', i))
				}
			}

			if(!is.null(df)) {
				saveRDS(df, file = out.file)
				# Delete the extracted folder
				unlink(extract.dir, recursive = TRUE, force = TRUE)
				if(cleanup) {
					unlink(zipfile)
				}
				invisible(df)
			}
		}

		if(is.null(df)) {
			stop('No data file found.')
		}
	} else {
		warning(paste0('File already exists: ', out.file,
					   ' Set redownload = TRUE to reprocess the file.'))
		df <- readRDS(out.file)
		invisible(df)
	}
}
