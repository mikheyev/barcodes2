library(ggplot2)
library(aod)
library(reshape)
setwd("/Volumes/genefs/MikheyevU/sasha/projects/barcodes2")
data <- read.csv("data/errors.csv")

ggplot(data,aes(individual))+geom_histogram()+theme_bw()+facet_grid(.~treatment)

with(subset(data,gq>=99),tapply(correct,treatment,summary))
with(subset(data,gq>=30),wilcox.test(correct~treatment))

logit.hq <- glm(correct ~  factor(treatment)+ factor(cycle) + gq + factor(individual), data = subset(data,gq >= 30), family = "binomial")
summary(logit.hq)
confint(logit.hq)	# print confidence intervals for log odds ratios
exp(coef(logit.hq))  # print log odds ratios
wald.test(b = coef(logit.hq), Sigma = vcov(logit.hq), Terms = 5:8) # test effect of library
