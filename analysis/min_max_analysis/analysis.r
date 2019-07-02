library(tidyr)
library(dplyr)
library(plyr)
library(reshape)
library(ggplot2)

setwd(".")

locs_min = read.csv("data/locs_min.csv", stringsAsFactors = TRUE)
locs_max = read.csv("data/locs_max.csv", stringsAsFactors = TRUE)
days_min = read.csv("data/days_min.csv", stringsAsFactors = TRUE)
days_max = read.csv("data/days_max.csv", stringsAsFactors = TRUE)

locs_min$devActivities <- gsub(" ", "", tolower(locs_min$devActivities))
locs_max$devActivities <- gsub(" ", "", tolower(locs_max$devActivities))
days_min$devActivities <- gsub(" ", "", tolower(days_min$devActivities))
days_max$devActivities <- gsub(" ", "", tolower(days_max$devActivities))

#### LOCs

max_num_elements <- ncol(do.call(rbind, strsplit(as.character(locs_min$devActivities),',')))
column_names <- paste("V", 1:max_num_elements, sep="")
locs_min <- locs_min %>% separate(devActivities, sep=',', column_names)
locs_min <- locs_min %>% gather(V, devActivities, column_names)

max_num_elements <- ncol(do.call(rbind, strsplit(as.character(locs_max$devActivities),',')))
column_names <- paste("V", 1:max_num_elements, sep="")
locs_max <- locs_max %>% separate(devActivities, sep=',', column_names)
locs_max <- locs_max %>% gather(V, devActivities, column_names)

locs_min$devActivities <- as.factor(revalue(locs_min$devActivities, c("apimanagement"="API management",
                                                                      "appenhancement"="App enhancement",
                                                                      "bugfixing"="Bug fixing",
                                                                      "codere-organization"="Code re-organization",
                                                                      "projectmanagement"="Project management",
                                                                      "sensing&communication"="Sensing & communication",
                                                                      "storagemanagement"="Storage management",
                                                                      "testing&debugging"="Testing & debugging",
                                                                      "userexperienceimprovement"="User experience improvement")))

locs_max$devActivities <- as.factor(revalue(locs_max$devActivities, c("apimanagement"="API management",
                                                            "appenhancement"="App enhancement",
                                                            "bugfixing"="Bug fixing",
                                                            "codere-organization"="Code re-organization",
                                                            "projectmanagement"="Project management",
                                                            "sensing&communication"="Sensing & communication",
                                                            "storagemanagement"="Storage management",
                                                            "testing&debugging"="Testing & debugging",
                                                            "userexperienceimprovement"="User experience improvement")))

locs_min$type <- 'Issues resolved with the minimum #LOCs'
locs_max$type <- 'Issues resolved with the maximum #LOCs'
global <- rbind(locs_min, locs_max)
global <- global[!is.na(global$devActivities),]
global <- global[global$devActivities != "",]

ggplot(data=global, aes(x=devActivities, fill=type)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1)) +
  scale_fill_manual(values=c("orange", "green4")) + 
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_max_locs_faceted.pdf", scale = 0.8, height = 20 , unit = "cm")

ggplot(data=global, aes(x=devActivities, fill=type)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1)) +
  scale_fill_manual(values=c("orange", "green4")) + 
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_max_locs.pdf", scale = 0.8, height = 15 , unit = "cm")

global_max <- global[global$type == "Issues resolved with the maximum #LOCs",]

ggplot(data=global_max, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="orange") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./max_locs.pdf", scale = 0.8, height = 15 , unit = "cm")

ggplot(data=global_max, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="orange") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./max_locs_faceted.pdf", scale = 0.8, height = 20 , unit = "cm")

global_min <- global[global$type == "Issues resolved with the minimum #LOCs",]

ggplot(data=global_min, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="green4") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_locs.pdf", scale = 0.8, height = 15 , unit = "cm")

ggplot(data=global_min, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="green4") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_locs_faceted.pdf", scale = 0.8, height = 20 , unit = "cm")

#### Days

max_num_elements <- ncol(do.call(rbind, strsplit(as.character(days_min$devActivities),',')))
column_names <- paste("V", 1:max_num_elements, sep="")
days_min <- days_min %>% separate(devActivities, sep=',', column_names)
days_min <- days_min %>% gather(V, devActivities, column_names)

max_num_elements <- ncol(do.call(rbind, strsplit(as.character(days_max$devActivities),',')))
column_names <- paste("V", 1:max_num_elements, sep="")
days_max <- days_max %>% separate(devActivities, sep=',', column_names)
days_max <- days_max %>% gather(V, devActivities, column_names)

days_min$devActivities <- as.factor(revalue(days_min$devActivities, c("apimanagement"="API management",
                                                            "appenhancement"="App enhancement",
                                                            "bugfixing"="Bug fixing",
                                                            "codere-organization"="Code re-organization",
                                                            "projectmanagement"="Project management",
                                                            "sensing&communication"="Sensing & communication",
                                                            "storagemanagement"="Storage management",
                                                            "testing&debugging"="Testing & debugging",
                                                            "userexperienceimprovement"="User experience improvement")))

days_max$devActivities <- as.factor(revalue(days_max$devActivities, c("apimanagement"="API management",
                                                            "appenhancement"="App enhancement",
                                                            "bugfixing"="Bug fixing",
                                                            "codere-organization"="Code re-organization",
                                                            "projectmanagement"="Project management",
                                                            "sensing&communication"="Sensing & communication",
                                                            "storagemanagement"="Storage management",
                                                            "testing&debugging"="Testing & debugging",
                                                            "userexperienceimprovement"="User experience improvement")))

days_min$type <- 'Issues resolved after the minimum #days'
days_max$type <- 'Issues resolved after the maximum #days'
global <- rbind(days_min, days_max)
global <- global[!is.na(global$devActivities),]
global <- global[global$devActivities != "",]
global$devActivities < tolower(global$devActivities)

ggplot(data=global, aes(x=devActivities, fill=type)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1)) +
  scale_fill_manual(values=c("orange", "green4")) + 
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_max_days_faceted.pdf", scale = 0.8, height = 20, unit = "cm")

ggplot(data=global, aes(x=devActivities, fill=type)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1)) +
  scale_fill_manual(values=c("orange", "green4")) + 
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_max_days.pdf", scale = 0.8, height = 15, unit = "cm")

global_max <- global[global$type == "Issues resolved after the maximum #days",]

ggplot(data=global_max, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="orange") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./max_days_faceted.pdf", scale = 0.8, height = 20, unit = "cm")

ggplot(data=global_max, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="orange") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./max_days.pdf", scale = 0.8, height = 15, unit = "cm")

global_min <- global[global$type == "Issues resolved after the minimum #days",]

ggplot(data=global_min, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="green4") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 9)) +
  facet_grid(~issueType) + 
  theme(axis.text.x=element_text(size=8, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_days_faceted.pdf", scale = 0.8, height = 20, unit = "cm")

ggplot(data=global_min, aes(x=devActivities)) +
  geom_bar(aes(y = (..count..)), position=position_dodge(1), fill="green4") +
  geom_text(aes( label = ..count..,
                 y= ..count.. ), stat= "count", vjust = -.5, position = position_dodge(1), size=2.5) +
  theme_bw() +
  xlab("Types of development activities") + ylab("Frequencies of commits") +
  theme(legend.position="bottom", legend.title = element_blank(), legend.box.background = element_rect(colour = "black")) +
  guides(color=guide_legend(title="")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 35)) +
  theme(axis.text.x=element_text(size=10, angle=70, hjust=1), axis.title=element_text(size=10), axis.text.y = element_blank())

ggsave("./min_days.pdf", scale = 0.8, height = 15, unit = "cm")


