# load the input file
input_rmd_issues <- read.csv("./results/issues-removed.csv")

# regex to extract the documented commits for each type of issues

draw_regex <- subset(input_rmd_issues, grepl("[Dd]raw*|[Aa]lloca*|[Mm]emor*", input_rmd_issues$REMOVAL_COMMIT_MSG))
rec_regex <- subset(input_rmd_issues, grepl("[Cc]ursor*|[Rr]ecycle*|[Tt]ypedArray*|[Vv]elocityTrack*", input_rmd_issues$REMOVAL_COMMIT_MSG))
vholder_regex <- subset(input_rmd_issues, grepl("[Vv]iewHolder*|[Aa]dapter*|[Ll]istView|[Ss]crol*", input_rmd_issues$REMOVAL_COMMIT_MSG))
hleak_regex <- subset(input_rmd_issues, grepl("[Hh]andle|[Ww]eakReferenc|[Mm]essageQueue|[Ll]eak", input_rmd_issues$REMOVAL_COMMIT_MSG))
sparse_regex <- subset(input_rmd_issues, grepl("[Ss]parseArray*|[Hh]ashMap*", input_rmd_issues$REMOVAL_COMMIT_MSG))
usevalue_regex <- subset(input_rmd_issues, grepl("[Vv]alue*|[Dd]ouble().*|[L]ong().*", input_rmd_issues$REMOVAL_COMMIT_MSG))
fmath_regex <- subset(input_rmd_issues, grepl("[Ff]loatMath", input_rmd_issues$REMOVAL_COMMIT_MSG))
others <- subset(input_rmd_issues, grepl("[Ll]int|[Ww]arn|[Pp]erf.*", input_rmd_issues$REMOVAL_COMMIT_MSG))

draw_regex1 <- subset(draw_regex, draw_regex$ISSUE_TYPE == "DrawAllocation")
rec_regex1 <- subset(rec_regex, rec_regex$ISSUE_TYPE == "Recycle")
vholder_regex1 <- subset(vholder_regex, vholder_regex$ISSUE_TYPE == "ViewHolder")
hleak_regex1 <- subset(hleak_regex, hleak_regex$ISSUE_TYPE == "HandlerLeak")
sparse_regex1 <- subset(sparse_regex, sparse_regex$ISSUE_TYPE == "UseSparseArrays")
usevalue_regex1 <- subset(usevalue_regex, usevalue_regex$ISSUE_TYPE == "UseValueOf")
fmath_regex1 <- subset(fmath_regex, fmath_regex$ISSUE_TYPE == "FloatMath")

# writing the obtained result into  CSv file

write.csv(draw_regex1, file = "./results/DrawAllocation.csv")
write.csv(rec_regex1, file = "./results/Recycle.csv")
write.csv(vholder_regex1, file = "./results/ViewHolder.csv")
write.csv(hleak_regex1, file = "./results/HandlerLeak.csv")
write.csv(sparse_regex1, file = "./results/UseSparseArray.csv")
write.csv(usevalue_regex1, file = "./results/UsealueOf.csv")
write.csv(fmath_regex1, file = "./results/FloatMath.csv")
write.csv(others, file = "./results/others.csv")

complete.dat <- rbind(draw_regex1, rec_regex1, vholder_regex1, hleak_regex1, sparse_regex1, usevalue_regex1, fmath_regex1, others)
write.csv(complete.dat, file = "./results/documented_Performance_Issues.csv")
# printing the number of performance issues obtained from each regex

dra <- length(draw_regex$ISSUE_TYPE[draw_regex$ISSUE_TYPE == "DrawAllocation"])
print(paste0("DrawAllocation Count: ", dra))
rec <- length(rec_regex$ISSUE_TYPE[rec_regex$ISSUE_TYPE == "Recycle"])
print(paste0("Recycle Count: ", rec))
vh <- length(vholder_regex$ISSUE_TYPE[vholder_regex$ISSUE_TYPE == "ViewHolder"])
print(paste0("ViewHolder Count: ", vh))
hl <- length(hleak_regex$ISSUE_TYPE[hleak_regex$ISSUE_TYPE == "HandlerLeak"])
print(paste0("HandlerLeak Count: ", hl))
sparse <- length(sparse_regex$ISSUE_TYPE[sparse_regex$ISSUE_TYPE == "UseSparseArrays"])
print(paste0("UseSparseArray Count: ", sparse))
valueof <- length(usevalue_regex$ISSUE_TYPE[usevalue_regex$ISSUE_TYPE == "UseValueOf"])
print(paste0("UseValueOf Count: ", valueof))
fmath <- length(fmath_regex$ISSUE_TYPE[fmath_regex$ISSUE_TYPE == "FloatMath"])
print(paste0("FloatMath Count: ", fmath))

# printing the number of performance issues obtained from "Other" regex

print(paste0("Other Issue Types"))
dra_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "DrawAllocation"])
print(paste0("DrawAllocation Other Count: ", dra_other))
rec_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "Recycle"])
print(paste0("Recycle Other Count: ", rec_other))
vh_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "ViewHolder"])
print(paste0("ViewHolder Other Count: ", vh_other))
hl1 <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "HandlerLeak"])
print(paste0("HandlerLeak Other Count: ", hl1))
sparse_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "UseSparseArrays"])
print(paste0("UseSparseArray Other Count: ", sparse_other))
valueof_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "UseValueOf"])
print(paste0("UseValueOf Other Count: ", valueof_other))
fmath_other <- length(others$ISSUE_TYPE[others$ISSUE_TYPE == "FloatMath"])
print(paste0("FloatMath Other Count: ", fmath_other))