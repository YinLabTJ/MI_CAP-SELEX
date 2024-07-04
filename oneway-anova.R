tmp=read.table("anova.forR.xls",header = FALSE);
x<-tmp[,3]
A<-factor(t(tmp[,1]))
lamp<-data.frame(x,A)
lamp
lamp.aov<-aov(x~A,data=lamp)
summary(lamp.aov)
