library(sm)
library(sp)
library(vioplot)
library(ggplot2)
library(raster)
library(reshape2)
library(scales)

# Violin Plot For No Of Remaining Performance Issues.

remain_input <- read.csv("./results/frequency_remained_issues.csv")
d <- melt(remain_input + 0.0001)
write.csv(d, file = "./results/meltdata_Rq2.csv")
par(las=2,bty="l")
#Issues_rem=remain_input$ISSUE_TYPE
#alive_rem=remain_input$Remain
remain_melt <- read.csv("./results/meltdata_Rq2.csv")
#myPlot <- ggplot(inputfile, aes(inputfile$ISSUE_TYPE, inputfile$issuenum)) +
myPlot <- ggplot(remain_melt, aes(remain_melt$variable, remain_melt$value)) +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
#scale_y_continuous(breaks = c(0.00001,0.0001,0.001,0.01,0.1,1,10,100,1000), trans = "log10") +
geom_violin(trim=FALSE, fill="#B2BEB5")+
labs(x="Issue Types", y = "Days")+
geom_boxplot(width=0.05)+
theme_classic() + theme(axis.text=element_text(size=12), axis.title=element_text(size=16,face="bold"))
pdf(paste("./plots/", "violinplotRemPIssues_RQ2", ".pdf", sep=""), width=11)
print(myPlot)
dev.off()