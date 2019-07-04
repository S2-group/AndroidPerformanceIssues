# Download Range

my_vector1=c(8,10,44,35,140,65,131,62,104,37,37,9,27,2,6,2,2,1)
pdf(paste("./", "downloadapps_barplot", ".pdf", sep=""), width=11, height=7)
par(mgp=c(2,1,0),mar=c(12,12,5,5)+0.1)
xx1 <- barplot(my_vector1, col = "#B2BEB5", ylim = c( 0 , 200 ), names.arg=c("1-5","5-10","10-50","50-100","100-500","500-1000","1000-5000","5000-10000","10000-50000","50000-100000","100000-500000","500000-1000000","1000000-5000000","5000000-10000000","10000000-50000000","50000000-100000000","100000000-500000000","1000000000-5000000000"), las=2, cex.axis = 0.8, cex.names=0.8)
title(ylab="Frequency", line = 3)
title(xlab="Download Range", line = 8)
text(x = xx1, y = my_vector1, label = my_vector1, pos = 3, cex = 0.8, col = "black")
dev.off()

# App Categories

my_vector1=c(11,10,2,34,21,53,33,20,84,15,16,24,17,4,22,14,12,80,5,18,171,26,25,6)
pdf(paste("./", "appcategories_barplot", ".pdf", sep=""), width=11, height=7)
par(mgp=c(2,1,0),mar=c(12,12,5,5)+0.1)
xx1 <- barplot(my_vector1, col = "#B2BEB5", ylim = c( 0 , 200 ), names.arg=c("Books&Reference","Business","Comics","Communication","Customization","Education","Entertainment","Finance","Games","HealthandFitness","Libraries&Demo","Lifestyle","Media&Video","Medicine","Musicandaudio","News&Magazines","Photography","Productivity","Shopping","Social","Tools","Transportation","Travel&Local","Weather"), las=2, cex.axis = 0.8, cex.names=0.8)
title(ylab="Frequency", line = 3)
title(xlab="App Categories", line = 8)
text(x = xx1, y = my_vector1, label = my_vector1, pos = 3, cex = 0.8, col = "black")
dev.off()


#commits
inputdata <- read.csv("./targetedApps.csv")
toPlot <- boxplot(inputdata$Commits)
toPlot$out <- NULL
toPlot$group <- NULL
pdf(paste("./", "forcommits_boxplot", ".pdf", sep=""), width=3, height = 4)
bxp(toPlot, xlab="", ylab="Commits per repository", ylim = c(0, 500), col = "#B2BEB5")
dev.off()

# contributors

toPlot <- boxplot(inputdata$Contributors)
toPlot$out <- NULL
toPlot$group <- NULL
pdf(paste("./", "forcontributors_boxplot", ".pdf", sep=""), width=3, height = 4)
bxp(toPlot, xlab="", ylab="Contributors per repository", ylim = c(0, 10), col = "#B2BEB5")
dev.off()


# java files

toPlot <- boxplot(inputdata$JavaFiles)
toPlot$out <- NULL
# toPlot$group <- NULL
pdf(paste("./", "forjavafiles_boxplot", ".pdf", sep=""), width=3, height = 4)
bxp(toPlot, xlab="", ylab="Java files", col = "#B2BEB5")
dev.off()

# loc

toPlot <- boxplot(inputdata$LinesOfCodesJava)
toPlot$out <- NULL
# toPlot$group <- NULL
pdf(paste("./", "forloc_boxplot", ".pdf", sep=""), width=3, height = 4)
bxp(toPlot, xlab="", ylab="Lines of Java code", col = "#B2BEB5")
dev.off()


# Download Range

df <- data.frame(dose=c("1-5","5-10","10-50","50-100","100-500","500-1000","1000-5000","5000-10000","10000-50000","50000-100000","100000-500000","500000-1000000","1000000-5000000","5000000-10000000","10000000-50000000","50000000-100000000","100000000-500000000","1000000000-5000000000"), len=c(8,10,44,35,140,65,131,62,104,37,37,9,27,2,6,2,2,1))
ggplot(data=df, aes(x=dose, y=len)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=len), vjust=-0.3, size=3.5)+
  theme_minimal() + labs(x = "Download Range", y = "Frequency") + theme(axis.text.x = element_text(angle = 70, hjust = 1))
ggsave("./download__range.pdf", scale = 0.8, height = 10)

# App categories

df <- data.frame(dose=c("Books&Reference","Business","Comics","Communication","Customization","Education","Entertainment","Finance","Games","HealthandFitness","Libraries&Demo","Lifestyle","Media&Video","Medicine","Musicandaudio","News&Magazines","Photography","Productivity","Shopping","Social","Tools","Transportation","Travel&Local","Weather"),len=c(11,10,2,34,21,53,33,20,84,15,16,24,17,4,22,14,12,80,5,18,171,26,25,6))
ggplot(data=df, aes(x=dose, y=len)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=len), vjust=-0.3, size=3.5)+ theme_minimal() + labs(x = "Apps Categories", y = "Frequency") + theme(axis.text.x = element_text(angle = 70, hjust = 1))
ggsave("./apps_categories.pdf", scale = 0.8, height = 10)
