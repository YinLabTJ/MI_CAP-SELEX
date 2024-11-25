tmp=read.table("anova.forR.xls",header = FALSE);
x<-tmp[,3]
A<-factor(t(tmp[,1]))
lamp<-data.frame(x,A)
oneway.test(x~A, data = lamp, var.equal = F)
