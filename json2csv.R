library(jsonlite)
library(lubridate)

json_file <- "~/Downloads/18.json"

if (length(args)!=1) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  json_file <- args[0]
}

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
answers[, "Time Used"] <- lubridate:::.strptime(js$submissions[,"Last Edit Time"], "%Y-%m-%dT%H:%M:%OS%OO") - lubridate:::.strptime(js$submissions[,"First Edit Time"], "%Y-%m-%dT%H:%M:%OS%OO")
questions <- t(sapply(js$submissions$questions,function(x) x[["Question Is Correct"]]))
questions <- as.data.frame(questions)
names(questions) <- paste0("Q", 1:ncol(questions))
qstats = apply(questions[,], 2, function(x) length(which(x))) / nrow(questions[,])
questions$TotalCorrect = rowSums(questions)
questions$PctCorrect = 100.0(questions$TotalCorrect / (ncol(questions)-1))
answers <- cbind(answers, questions)

write.table(answers, file="~/Downloads/test_quiz.csv", sep=",", row.names = FALSE)

print(answers)

## Question stats

print(qstats)
