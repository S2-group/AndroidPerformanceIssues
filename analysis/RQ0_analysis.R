library(circlize)
library(reshape2)
library(ggplot2)
library(sm)
library(vioplot)
library(raster)
library(reshape2)
library(scales)


# Counting All Performance issues.
print(paste0("1. Counting All Performance issues"))

inputall_pissues <- read.csv("./results/all_identified_issues.csv")
count_draw <- length(which(inputall_pissues$ISSUE_TYPE == "DrawAllocation"))
count_rec <- length(which(inputall_pissues$ISSUE_TYPE == "Recycle"))
count_vholder <- length(which(inputall_pissues$ISSUE_TYPE == "ViewHolder"))
count_hleak <- length(which(inputall_pissues$ISSUE_TYPE == "HandlerLeak"))
count_sparse <- length(which(inputall_pissues$ISSUE_TYPE == "UseSparseArrays"))
count_usevalue <- length(which(inputall_pissues$ISSUE_TYPE == "UseValueOf"))
count_fmath <- length(which(inputall_pissues$ISSUE_TYPE == "FloatMath"))
count_vtag <- length(which(inputall_pissues$ISSUE_TYPE == "ViewTag"))
count_wlock <- length(which(inputall_pissues$ISSUE_TYPE == "Wakelock"))
pdf(paste("./plots/", "countAllPerfIssues_RQ0", ".pdf", sep=""), width=11)
par(mgp=c(2,1,0),mar=c(12,12,5,5)+0.1)
maincount=c(count_draw,count_fmath,count_hleak,count_rec,count_sparse,count_usevalue,count_vholder,count_vtag,count_wlock)
issue_name <- barplot(maincount, col= "#B2BEB5", ylim = c( 0 , 600 ), names.arg=c("DrawAllocation","FloatMath","HandlerLeak","Recycle","UseSparseArrays","UseValueOf","ViewHolder","ViewTag","Wakelock"), las=2, cex.axis = 1.3, cex.names=1.3)
mtext("Days", side=2, line=4, cex = 1.8)
mtext("Issue Types", side=1, line=10.4, cex = 1.8)
text(x = issue_name, y = maincount, label = maincount, pos = 3, cex = 1, col = "black", cex.axis = 1.3)
dev.off()


# Emerging Patterns
print(paste0("2. Emerging Patterns"))

emerg_vector=c(131,124,111,96,69,41)
pdf(paste("./plots/", "emergingTrendsCount_RQ0", ".pdf", sep=""), width=11)
par(mgp=c(2,1,0),mar=c(12,12,5,5)+0.1)
xx1 <- barplot(emerg_vector, col = "#B2BEB5", ylim = c( 0 , 160 ), names.arg=c("STICK","REF","BEG","IRF","INJREM","GRAD"), las=2, cex.axis = 1.3, cex.names=1.3)
mtext("Frequency", side=2, line=4, cex = 1.8)
mtext("Emerging Trend Categories", side=1, line=6, cex = 1.8)
text(x = xx1, y = emerg_vector, label = emerg_vector, pos = 3, cex = 1, col = "black", cex.axis = 1.3)
dev.off()





# Violin Plot for number of performance issues per app.
print(paste0("3. Violin Plot For Number Of Performance Issues Per App."))

violin_input <- read.csv("./results/frequency_identiified-issues.csv")
d <- melt(violin_input + 0.0001)
write.csv(d, file = "./results/meltfile.csv")
par(las=2,bty="l")
violin_melt <- read.csv("./results/meltfile.csv")
#myPlot <- ggplot(inputfile, aes(inputfile$ISSUE_TYPE, inputfile$issuenum)) +
myPlot <- ggplot(violin_melt, aes(violin_melt$variable, violin_melt$value)) +
  #scale_y_continuous(breaks = c(0.000001,0.00001,0.0001,0.001,0.01,0.1,1,10,100,1000), trans = "log10") +
  #scale_y_log10() +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  geom_violin(trim = FALSE, fill="#B2BEB5")+
  labs(x="Issue Types", y = "Days")+
  geom_boxplot(width=0.05)+
  theme_classic() + theme(axis.text=element_text(size=12), axis.title=element_text(size=16,face="bold"))
pdf(paste("./plots/", "violinplotAllPIssues_RQ0", ".pdf", sep=""), width=11)
print(myPlot)
dev.off()



