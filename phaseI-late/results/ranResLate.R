setwd("C:/Users/JINHU/Documents/ProjectCode/CFO-lateonset")
setwd("C:/Users/JINHU/OneDrive - connect.hku.hk/文档/ProjectCode/TITE-CFO")
source("utilities.R")

nsimu = 5000
target <- 0.3
diff <- 0.05
res.ls <- list()
flag <- 1
for (diff in c(0.05, 0.07, 0.1, 0.15)){
    file.name <- paste0("./phaseI-late/results/", "Simu_", nsimu, "_phi_", 100*target,  "_random_", 100*diff,  ".RData")
    load(file.name)
    res.ls[[flag]] <-  post.process.random(results)[c("cfo", "boin", "crm"), ]
    print(res.ls[[flag]])
    flag <- flag + 1
}


Ress <- list()
for (nam in names(res.ls[[1]])){
    
    cRes <- do.call(rbind, lapply(res.ls, function(x){x[[nam]]}))
    colnames(cRes) <- row.names(res.ls[[1]])
    Ress[[nam]] <- cRes
}

singlePlot <- function(cRes, main="", ylab="Percentage (%)"){
    plot(cRes[, 1]*100, type = "b", col=1, lwd=2, lty=1, pch=1, ylim=c(min(cRes)-0.02, max(cRes)+0.02)*100, 
         xlab="Prob diff around the target", main=main, 
         xaxt="n", ylab=ylab)
    lines(cRes[, 2]*100, type = "b", col=2, lwd=2, lty=2, pch=2)
    lines(cRes[, 3]*100, type = "b", col=3, lwd=2, lty=3, pch=3)
    axis(1, at=1:4, labels=c("0.05", "0.07", "0.10", "0.15"))
    #legend("topleft", toupper(colnames(cRes)), col=1:3, lty=1:3, pch=1:3, lwd=2)
}
singlePlot.dur <- function(cRes, main="", ylab="Percentage (%)"){
    plot(cRes[, 1], type = "b", col=1, lwd=2, lty=1, pch=1, ylim=c(min(cRes)-2, max(cRes)+2), 
         xlab="Prob diff around the target", main=main, 
         xaxt="n", ylab=ylab)
    lines(cRes[, 2], type = "b", col=2, lwd=2, lty=2, pch=2)
    lines(cRes[, 3], type = "b", col=3, lwd=2, lty=3, pch=3)
    axis(1, at=1:4, labels=c("0.05", "0.07", "0.10", "0.15"))
    #legend("topleft", toupper(colnames(cRes)), col=1:3, lty=1:3, pch=1:3, lwd=2)
}


fig.name <- paste0("./phaseI-late/results/", "SimuLate_", nsimu, "_phi_", 100*target,  "_random",  ".png")
fig.name <- paste0("./phaseI-late/results/", "SimuLate_", nsimu, "_phi_", 100*target,  "_randomOral",  ".png")
png(filename=fig.name, unit="in", height=7, width=8, res=300)
par(mfrow=c(2, 2), oma = c(2,1,1,1))
singlePlot(Ress[[1]], main="(A) MTD Selection")
singlePlot(Ress[[2]], main="(B) MTD Allocation")
singlePlot(Ress[[3]], main="(C) Overdose Selection")
#singlePlot(Ress[[4]], main="(D) Overdose Allocation")
#singlePlot(Ress[[5]], main="Risk of High Toxicity")
#singlePlot(Ress[[6]], main="(E) Average DLT Rate")
singlePlot.dur(Ress[[7]], main="(D) Average Trial Duration",  ylab="Time (in months)")
par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
plot(0, type = 'l', bty = 'n', xaxt = 'n', yaxt = 'n')
legend("bottom", toupper(paste0("TITE-", colnames(Ress[[1]]))), col=1:3, lty=1:3, pch=1:3, lwd=2, 
       xpd=TRUE, horiz = TRUE, cex = 1, seg.len=1)
par(mfrow=c(1, 1))
dev.off()

