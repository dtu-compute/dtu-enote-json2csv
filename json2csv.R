library(jsonlite)

js <- stream_in(con=file("~/Downloads/export.json"))
js

str(js)
js$meta
names(js$submissions[[1]])


js$submissions[[1]][["Student ID"]]
js$submissions[[1]][["Attempt No"]]
length(js$submissions[[1]]$questions)

(js$submissions[[1]]$questions[[10]])
(js$submissions[[1]]$questions[[8]])

# Note that counters start from 0. E.g. "Question Students Answer"

## Collecting the answers
answers <- js$submissions[[1]][,c("Student ID", "Student Name", "Attempt No", "Quiz Attempt Number", "Time Used" )]
questions <- t(sapply(js$submissions[[1]]$questions,function(x) x[["Question Is Correct"]]))
questions <- as.data.frame(questions)
names(questions) <- paste0("Q", 1:ncol(questions))
answers <- cbind(answers, questions)

write.table(answers, file="~/teaching/IntroStat/test_quiz.csv", sep=",", row.names = FALSE)
