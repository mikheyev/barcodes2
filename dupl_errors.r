library(ggplot2)
library(aod)
library(reshape)
setwd("/Volumes/genefs/MikheyevU/sasha/projects/barcodes2")
data_ants <- read.csv("data/errors.csv")
data_ants$type <- "ants"
data_yeast <- read.csv("data/yeast/errors.csv")
data_yeast$type <- "yeast"
data <- rbind(data_yeast,data_ants)
breaks <- c(1, 19, 30, 40, 70, 100)
gq_cutoff <- 20
data$bin <- cut(data$gq, breaks)
pdf("/Users/sasha/Dropbox/Manuscripts/barcodes2/plots/gq.pdf",width=4,height=8)
p2 <- ggplot(na.omit(subset(data,treatment="nodup")),aes(x=bin, y=correct)) + geom_jitter(alpha=0.1)+facet_grid(type~.)+theme_bw()+xlab("Genotype quality")+ylab("Correct")+scale_y_continuous(breaks=c(0,1))+ylim(0,1) + theme(strip.background = element_blank(),strip.text.y = element_text(size = 20),axis.text.y =  theme_blank(),axis.ticks.y = theme_blank())

p1 <- ggplot(na.omit(data),aes(x=bin,fill=factor(treatment)))+ geom_histogram(breaks=breaks,position="dodge")+facet_grid(type~.,scales = "free_y")+theme_bw()+scale_fill_manual(values=c("black","grey"))+theme(strip.background = element_blank(),strip.text.y = element_text(size = 20),legend.title=element_blank(),legend.key = element_blank(),legend.direction = "horizontal",legend.position="top") +xlab("Genotype quality")
grid.arrange(p1,p2,nrow=2)
dev.off()


logit.ants <- glm(correct ~  factor(treatment)+ factor(cycle) + gq + factor(individual), data = subset(data,type == "ants" & gq >= gq_cutoff), family = "binomial")
summary(logit.ants)


confint(logit.ants)	# print confidence intervals for log odds ratios
exp(coef(logit.ants))  # print log odds ratios
wald.test(b = coef(logit.ants), Sigma = vcov(logit.ants), Terms = 5:8) # test effect of library


logit.yeast <- glm(correct ~  factor(treatment)+ factor(cycle) + gq + factor(individual), data = subset(data,type == "yeast"& gq >= gq_cutoff), family = "binomial")
summary(logit.yest)

confint(logit.yeast)	# print confidence intervals for log odds ratios
exp(coef(logit.yeast))  # print log odds ratios



summary(subset(data,type == "ants" & gq >= gq_cutoff & treatment == "dup")$correct)
summary(subset(data,type == "ants" & gq >= gq_cutoff & treatment == "nodup")$correct)
summary(subset(data,type == "yeast" & gq >= gq_cutoff & treatment == "dup")$correct)
summary(subset(data,type == "yeast" & gq >= gq_cutoff & treatment == "nodup")$correct)


# sample-to-sample variability

logit.ants.nodup <- glm(correct ~  factor(cycle) + gq + factor(individual), data = subset(data,type == "ants" & gq >= gq_cutoff & treatment == "nodup"), family = "binomial")
summary(logit.ants.nodup)
wald.test(b = coef(logit.ants.nodup), Sigma = vcov(logit.ants.nodup), Terms = 4:7)
logit.ants.dup <- glm(correct ~  factor(cycle) + gq + factor(individual), data = subset(data,type == "ants" & gq >= gq_cutoff & treatment == "dup"), family = "binomial")
summary(logit.ants.dup)
wald.test(b = coef(logit.ants.dup), Sigma = vcov(logit.ants.dup), Terms = 4:7)

logit.yeast.nodup <- glm(correct ~  factor(cycle) + gq + factor(individual), data = subset(data,type == "yeast" & gq >= gq_cutoff & treatment == "nodup"), family = "binomial")
summary(logit.yeast.nodup)
wald.test(b = coef(logit.yeast.nodup), Sigma = vcov(logit.yeast.nodup), Terms = 4:5) # test effect of library

logit.yeast.dup <- glm(correct ~  factor(cycle) + gq + factor(individual), data = subset(data,type == "yeast" & gq >= gq_cutoff & treatment == "dup"), family = "binomial")
summary(logit.yeast.dup)
wald.test(b = coef(logit.yeast.dup), Sigma = vcov(logit.yeast.dup), Terms = 4:5) # test effect of library