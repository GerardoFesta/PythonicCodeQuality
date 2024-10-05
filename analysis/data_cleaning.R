data = read.csv('../dataset/NicheSonarMergedcsv')
data = subset(data, select = -c(Stars,Commits,Lines.of.Code,Architecture,Community,Continuous.Integration,Documentation,History,Issues,License,Unit.Testing))
data = subset(data, select = -c(A1_Elements,A2_Elements,B1_Elements,B2_Elements,C1_Elements,C2_Elements))
data = subset(data, select = -c(false_positive_issues,reopened_issues, open_issues, comment_lines,confirmed_issues,wont_fix_issues,classes,statements,lines_to_cover,security_hotspots_reviewed_status,lines))
data = subset(data, select = -c(security_hotspots_reviewed))
data = subset(data, select = -c(development_cost))
data = subset(data, select = -c(functions, effort_to_reach_maintainability_rating_a, security_review_rating))

#transform the Engineered.Ml.Feature column into a numeric (0-1 from N-Y)
data$Engineered.ML.Project = as.numeric(data$Engineered.ML.Project == "Y")

#Delete all rows where PY_Assign Multi Targets and PY_Call Star are 0,PY_List Comprehension,PY_Dict Comprehension,PY_Set Comprehension,PY_Truth Value Test,PY_Chain Compare,PY_For Multi Targets,PY_For Else are all zero
#id est, delete rows where pythonic extraction failed
data = data[data$PY_Assign.Multi.Targets != 0 | data$PY_Call.Star != 0 | data$PY_List.Comprehension != 0 | data$PY_Dict.Comprehension != 0 | data$PY_Set.Comprehension != 0 | data$PY_Truth.Value.Test != 0 | data$PY_Chain.Compare != 0 | data$PY_For.Multi.Targets != 0 | data$PY_For.Else != 0,]

#Delete all rows where Assign Multi Targets and Call Star are 0,List Comprehension,Dict Comprehension,Set Comprehension,Truth Value Test,Chain Compare,For Multi Targets,For Else are all zero
#id est, delete rows where non-pythonic extraction failed
data = data[data$Assign.Multi.Targets != 0 | data$Call.Star != 0 | data$List.Comprehension != 0 | data$Dict.Comprehension != 0 | data$Set.Comprehension != 0 | data$Truth.Value.Test != 0 | data$Chain.Compare != 0 | data$For.Multi.Targets != 0 | data$For.Else != 0,]


#delete column sqale_rating since it's always 1, line_coverage and coverage since they are always 0
data = subset(data, select = -c(sqale_rating, line_coverage, coverage))

data$tot_pythonic = data$PY_Assign.Multi.Targets + data$PY_Call.Star + data$PY_List.Comprehension + data$PY_Dict.Comprehension + data$PY_Set.Comprehension + data$PY_Truth.Value.Test + data$PY_Chain.Compare + data$PY_For.Multi.Targets + data$PY_For.Else

data$tot_non_pythonic = data$Assign.Multi.Targets + data$Call.Star + data$List.Comprehension + data$Dict.Comprehension + data$Set.Comprehension + data$Truth.Value.Test + data$Chain.Compare + data$For.Multi.Targets + data$For.Else
data$pythonic_percentage = data$tot_pythonic / (data$tot_pythonic + data$tot_non_pythonic)

write.csv(data, '../dataset/NicheSonarMergedCleaned.csv', row.names = FALSE)
