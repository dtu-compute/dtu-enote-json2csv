library(jsonlite)
library(lubridate)

json_file <- "~/Downloads/18.json"
out_file <- "~/Downloads/test_quiz.csv"

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).\n")
} else if (length(args)==1) {
  json_file <- args[1]
} else if (length(args)>1) {
  json_file <- args[1]
  out_file <- args[2]
}

print(c("Loading file from", json_file))
print(c("Writing file to", out_file))

#js <- stream_in(con=file(json_file))
#js <- fromJSON(sprintf("[%s]", paste(readLines(json_file), collapse=",")))
js <- fromJSON(sprintf("%s", paste(readLines(json_file))))
js

str(js)
js$meta
names(js$submissions)


# Note that counters start from 0. E.g. "Question Students Answer"

## Collecting the answers
answers <- js$submissions[,c("Student ID", "Student Name", "Attempt No", "Quiz Attempt Number", "Time Used" )]
# Not needed since bug fixed.
#answers[, "Time Used"] <- lubridate:::.strptime(js$submissions[,"Last Edit Time"], "%Y-%m-%dT%H:%M:%OS%OO") - lubridate:::.strptime(js$submissions[,"First Edit Time"], "%Y-%m-%dT%H:%M:%OS%OO")
questions <- t(sapply(js$submissions$questions,function(x) x[["Question Is Correct"]]))
questions <- as.data.frame(questions)
questions_raw <- questions

names(questions) <- paste0("Q", 1:ncol(questions))
questions$TotalCorrect = rowSums(questions)
questions$PctCorrect = 100.0*(questions$TotalCorrect / (ncol(questions)-1))

answers <- cbind(answers, questions)

write.table(answers, file=out_file, sep=",", row.names = FALSE)

print(answers)

## Question stats

count_func <- function(x) length(which(x))
qstats = apply(questions_raw[,], 2, count_func) / nrow(questions[,])
print("SATISTICS")
print(qstats)
