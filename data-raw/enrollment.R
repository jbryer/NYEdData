library(readxl)
library(tidyverse)

enroll.districts.urls <- c(
	# Districts
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020AllStudents.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020Gender.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020Race.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020EconDisadv.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020LEP.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/District2020SWD.xlsx')
enroll.schools.urls <- c(
	# Schools
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020AllStudents.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020Gender.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020Race.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020EconDisadv.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020LEP.xlsx',
	'http://www.p12.nysed.gov/irs/statistics/enroll-n-staff/PublicSchool2020SWD.xlsx'
)

districts_enrollment <- data.frame()
for(i in enroll.districts.urls) {
	filename <- basename(i)
	download.file(i, paste0('data-raw/', filename))
	districts_enrollment <- rbind(districts_enrollment, read_excel(paste0('data-raw/', filename)))
}

schools_enrollment <- data.frame()
for(i in enroll.schools.urls) {
	filename <- basename(i)
	download.file(i, paste0('data-raw/', filename))
	schools_enrollment <- rbind(schools_enrollment, read_excel(paste0('data-raw/', filename)))
}

save(districts_enrollment, file = 'data/districts_enrollment.rda')
save(schools_enrollment, file = 'data/schools_enrollment.rda')
