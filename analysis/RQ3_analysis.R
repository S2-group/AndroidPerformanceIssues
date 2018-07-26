library(ggplot2)
library(sm)
library(vioplot)
library(scales)
library(survival)
library(MASS)
library(fitdistrplus)

# Violin plot using ggplot2

input_rmd_issues <- read.csv("./results/issues-removed.csv")
Issues=input_rmd_issues$ISSUE_TYPE
NoOfDays=input_rmd_issues$ISSUE_SURVIVED_TIME/86400
par(las=2,bty="l")
myPlot <- ggplot(input_rmd_issues, aes(Issues, NoOfDays)) +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +  
geom_violin(trim=FALSE, fill="#B2BEB5")+
labs(x="Issue Types", y = "Days")+
geom_boxplot(width=0.1)+
theme_classic() + theme(axis.text=element_text(size=12), axis.title=element_text(size=16,face="bold"))
pdf(paste("./plots/", "violinplotSurvivalTime_RQ3", ".pdf", sep=""), width=11)
print(myPlot)
dev.off()

install.packages("raster")
library(raster)

x <- c("DrawAllocation","FloatMath","HandlerLeak","Recycle","UseSparseArrays","UseValueOf","ViewHolder")
for (i in 1:length(x))
{
  details <- input_rmd_issues$ISSUE_SURVIVED_TIME[input_rmd_issues$ISSUE_TYPE == x[i]] / 86400
  print(paste("Statistic for issue type", x[i]))
  Minn <- min(details)
  Maxx <- max(details)
  Mediann <- median(details)
  Meann <- mean(details)
  SDD <- sd(details)
  CVV <- cv(details)
  print(paste("Minimum is", Minn))
  print(paste("Maximum is", Maxx))
  print(paste("Median is", Mediann))
  print(paste("Mean is", Meann))
  print(paste("Standard Deviation is", SDD))
  print(paste("Coefficient of variant is", CVV))
}




# KS Test For All Fitting Distribution

input_rmd_issues <- read.csv('./issues-removed.csv')
issues <- list("FloatMath", "UseSparseArrays", "UseValueOf", "HandlerLeak", "ViewHolder", "Recycle", "DrawAllocation")
for (i in 1:length(issues))
{
  print(paste0("Name of Performance issues: ", issues[[i]]))
  tmstmp <- input_rmd_issues$Time[input_rmd_issues$ISSUE_TYPE == issues[[i]]] / 86400
  distribution <- list("norm", "exp", "weibull", "gamma", "lnorm", "cauchy")
  for (j in 1:length(distribution))
  {
    print(paste0("Name of Distribution: ", distribution[[j]]))
    tit_ecdf <- paste(issues[[i]], distribution[[j]], "ECDF-Plot", sep = "-")
    tit_all <- paste(issues[[i]], distribution[[j]], "All-Plots", sep = "-")
    #pdf(paste("C:/Users/Teerath Das/Desktop/written/newpdfs/hags/", tit, ".pdf", sep=""), width=11, height=7)
    #png(paste('C:/Users/Teerath Das/Desktop/written/newpdfs/hags/', tit_all, ".png", sep=""), width=500, height=500)
    if (distribution[j] == "norm")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle",lower=c(0, 0))
      fum <- ks.test(tmstmp, "pnorm", fumle$estimate["mean"], fumle$estimate["sd"])
      print(fum)
    }
    
    if (distribution[j] == "exp")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle")
      fum <- ks.test(tmstmp, "pexp", fumle$estimate["rate"])
      print(fum)
    }
    
    if (distribution[j] == "lnorm")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle")
      fum <- ks.test(tmstmp, "plnorm", fumle$estimate["meanlog"], fumle$estimate["sdlog"])
      print(fum)
    }
    
    if (distribution[j] == "cauchy")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle",lower=c(0, 0))
      fum <- ks.test(tmstmp, "pcauchy", fumle$estimate["location"], fumle$estimate["scale"])
      print(fum)
    }
    
    if (distribution[j] == "gamma")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle",lower=c(0, 0))
      fum <- ks.test(tmstmp, "pgamma", fumle$estimate["shape"], fumle$estimate["rate"])
      print(fum)
    }
    
    if (distribution[j] == "weibull")
    {
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle",lower=c(0, 0))
      fum <- ks.test(tmstmp, "pweibull", fumle$estimate["shape"], fumle$estimate["scale"])
      print(fum)
      
    }
  }
}



# Calculating the CDF for all the distributions.

input_rmd_issues <- read.csv('./issues-removed.csv')
issues <- list("FloatMath", "UseSparseArrays", "UseValueOf", "HandlerLeak", "ViewHolder", "Recycle", "DrawAllocation")
for (i in 1:length(issues))
{
  print(paste0("Name of Performance issues: ", issues[[i]]))
  tmstmp <- input_rmd_issues$Time[input_rmd_issues$ISSUE_TYPE == issues[[i]]] / 86400
  distribution <- list("norm", "exp", "weibull", "gamma", "lnorm", "cauchy")
  for (j in 1:length(distribution))
  {
    print(paste0("Name of Distribution: ", distribution[[j]]))
    title_ecdf <- paste(issues[[i]], distribution[[j]], "ECDF-Plot", sep = "-")
    title_all <- paste(issues[[i]], distribution[[j]], "All-Plots", sep = "-")
    #pdf(paste("C:/Users/Teerath Das/Desktop/written/newpdfs/hags/", tit, ".pdf", sep=""), width=11, height=7)
    pdf(paste('./Distribution_Plots_RQ3/', title_all, ".pdf", sep=""), width=11, height=7)
    if (distribution[j] == "exp" | distribution[j] == "lnorm")
    {
      pdf(paste("./Distribution_Plots_RQ3/", title_ecdf, ".pdf", sep=""), width=11, height=7)
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle")
      cdfcomp(list(fumle),addlegend = FALSE, datacol = "red", fitcol = "blue", main=distribution[[j]], xlab="Decays (days)", ylab="CDF", do.points=F, lwd = 2, cex.axis = 1.8, cex.lab=1.5, cex.main=1.5)
      #plot(fumle)
      dev.off()
    }
    else
    {
      pdf(paste("./Distribution_Plots_RQ3/", title_ecdf, ".pdf", sep=""), width=11, height=7)
      fumle <- fitdist(tmstmp, distr = distribution[[j]], method="mle",lower=c(0, 0))
      cdfcomp(list(fumle),addlegend = FALSE, datacol = "red", fitcol = "blue", main=distribution[[j]], xlab="Decays (days)", ylab="CDF", do.points=F, lwd = 2, cex.axis = 1.8, cex.lab=1.5, cex.main=1.5)
      #plot(fumle)
      dev.off()
    }
    plot(fumle)
    dev.off()
  }
}