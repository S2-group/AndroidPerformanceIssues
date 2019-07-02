library(circlize)
library(reshape2)
library(ggplot2)
library(sm)
library(vioplot)
library(raster)
library(reshape2)
library(scales)

# All Performance issues and LOC plots.
print(paste0("1. All Performance issues and LOC plots"))

pcountfile <- read.csv("./results/PCount.csv")
inputfile <- "./results/inputreponame.csv"
inputfile_read  <- file(inputfile, open = "r")
while (length(oneLine <- readLines(inputfile_read, n = 1, warn = FALSE)) > 0)
{
print(paste0("Repo Name: ", oneLine))
data5 <- subset(pcountfile, pcountfile$RepoName == oneLine)
tme <- data5$LifeTime/86400
tot <- data5$TotalIssue
nkloc <- data5$LOC
pdf(paste("./plots/P_LOC_Plots_RQ1/", oneLine, ".pdf", sep=""), width=11)
par(mar=c(8, 8, 5, 5), xpd=TRUE)
y <- list(nkloc, tot)
plot(tme, y[[1]], xlim=c(0,2500), ylim=c(0,max(nkloc)), xlab = "",ylab = "", col = "red", las=1, type="n", cex.axis = 1.5)
lines(tme, y[[1]], col = "red")
#text(70, 14300, labels='INJREM', col='brown', cex = 1.5, lwd=3)
#arrows(5,13970, 274, 10500, length=0.1, lwd=3)
#text(1600, 1600, labels='STICK', col='brown', cex = 1.5, lwd=3)
#arrows(1600, 2000, 910, 13880, length=0.1, lwd=3, col = "pink")
#arrows(1600, 2000, 870, 6900, length=0.1, lwd=3, col = "yellow")
#nanoConverter
#text(900, 150, labels='IRF', col='brown', cex = 1.5, lwd=3)
#arrows(900, 250, 250, 900, length=0.1, lwd=3, col = "pink")
#arrows(900, 250, 265, 1060, length=0.1, lwd=3, col = "yellow")
#aGrep
#text(500, 920, labels='IRF', col='brown', cex = 1.5, lwd=3)
#arrows(500, 1000, 108, 2200, length=0.1, lwd=3)
par(new = TRUE)
plot(tme, y[[2]], xlab = "", ylab = "", xlim=c(0,2500), ylim = c(0,max(tot)), col = "blue", axes=FALSE, type="n")
axis(side = 4, las = 1, cex.axis = 1.5)
lines(tme, y[[2]], col = "blue")
mtext("Days", side=1, line=3.7, cex = 1.8)
mtext("#performance issues", side=4, line=3.7, cex = 1.8, col = "blue")
mtext("Lines of code", side=2, line=4.7, cex = 1.8, col = "red")
#legend("topright", inset=c(-0.11,-0.20), legend=c("LOC","P Issues"), text.col=c("red","blue"), pch=c(1,1), col=c("red","blue"), cex=1.0)
dev.off()
}
close(inputfile_read)



# Trends Tile for co-occurence of emerging pattern.
print(paste0("2. Trends Tile for co-occurence of emerging pattern."))

pdf(paste("./plots/", "multipleTrendsTile_RQ1", ".pdf", sep=""), width=11, height=7)
m <- matrix(c(0,  96, 48, 47, 11,
              0, 0, 46, 24, 11,
              0, 0, 0, 11, 6,
              0, 0, 0, 0, 3, 0, 0, 0, 0, 0),
            byrow = TRUE,
            nrow = 5, ncol = 5)
trends <- c("STICK", "REF", "BEG", "IRF", "INJREM", "GRAD")
dimnames(m) <- list(have = trends, prefer = trends)
print(m)
tableau.m <- melt(m)
print(tableau.m)
ttile <- ggplot(tableau.m, aes(have, prefer, fill=value)) + geom_tile() + geom_tile(colour="white",size=0.25) + scale_fill_gradientn(colours = c("#fefefe","#e6f598", "#fee08b","#fdae61","#d53e4f"), name="") + theme(axis.text.x = element_text(angle = 0)) + labs(x = "Patterns", y = "Patterns") + scale_x_discrete(position = "top") + scale_y_discrete(limits = rev(trends)) +theme(axis.text=element_text(size=13), axis.title=element_text(size=16,face="bold"), legend.text=element_text(size=14), legend.key.height=grid::unit(0.8,"cm"))
plot(ttile)
dev.off()

#m <- matrix(c(0,  44, 28, 18, 31, 11,
#              44, 0, 46, 64, 24, 11,
#              28, 46, 0, 23, 11, 6,
#              18, 64,  23, 0, 25, 0, 31, 24, 11, 25, 0, 3, 11, 11, 6, 0, 3, 0),
#            byrow = TRUE,
#            nrow = 6, ncol = 6)

#CramerV value

m <- matrix(c(0,  96, 48, 47, 11,
              96, 0, 46, 24, 11,
              48, 46, 0, 11, 6,
              47, 24, 11, 0, 3, 11, 11, 6, 3, 0),
            byrow = TRUE,
            nrow = 5, ncol = 5)
trends <- c("STICK", "REF", "BEG", "INJREM", "GRAD")
dimnames(m) <- list(have = trends, prefer = trends)
assocstats(m)



# Emerging Patterns
print(paste0("2. Emerging Patterns"))

emerg_vector=c(209,124,111,69,41)
pdf(paste("./plots/", "emergingTrendsCount_RQ0", ".pdf", sep=""), width=11)
par(mgp=c(2,1,0),mar=c(12,12,5,5)+0.1)
xx1 <- barplot(emerg_vector, col = "#B2BEB5", ylim = c( 0 , 250 ), names.arg=c("STICK","REF","BEG","INJREM","GRAD"), las=2, cex.axis = 1.3, cex.names=1.3)
mtext("Frequency", side=2, line=4, cex = 1.8)
mtext("Emerging Trend Categories", side=1, line=6, cex = 1.8)
text(x = xx1, y = emerg_vector, label = emerg_vector, pos = 3, cex = 1, col = "black", cex.axis = 1.3)
dev.off()