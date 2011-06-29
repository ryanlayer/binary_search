t_sm <- read.delim("t_sm_b_search_cuda.1.txt",header=F,sep=",")
t_gm <- read.delim("t_gm_b_search_cuda.1.txt",header=F,sep=",")
i_gm <- read.delim("i_gm_b_search_cuda.1.txt",header=F,sep=",")
i_sm <- read.delim("i_sm_b_search_cuda.1.txt",header=F,sep=",")
b <- read.delim("b_search_cuda.1.txt",header=F,sep=",")
s <- read.delim("sort_b_search_cuda.1.txt",header=F,sep=",")

#d_s<-unique(t_sm$V1)
#q_s<-unique(t_sm$V2)


d_s = 1000000
q_s = 500000
png("9800GT.png",width=1000)
for (d in d_s) {
	for (q in q_s) {
		t_sm_s<-subset(t_sm, V1==d & V2==q)
		t_gm_s<-subset(t_gm, V1==d & V2==q)
		i_gm_s<-subset(i_gm, V1==d & V2==q)
		i_sm_s<-subset(i_sm, V1==d & V2==q)
		b_s<-subset(b, V1==d & V2==q)
		s_s<-subset(s, V1==d & V2==q)

		x_min<-min(t_sm_s$V3, t_gm_s$V3,i_gm_s$V3,i_sm_s$V3,
				b_s$V3,s_s$V3)
				#bs_s$V3,is_s$V3,ts_s$V3)
		x_max<-max(t_sm_s$V3, t_gm_s$V3, i_gm_s$V3,i_sm_s$V3,
				b_s$V3,s_s$V3)
				#bs_s$V3,is_s$V3,ts_s$V3)
		y_min<-min(t_sm_s$V5, t_gm_s$V5, i_gm_s$V5,i_sm_s$V5,
				b_s$V5,s_s$V5)
				#bs_s$V3,is_s$V5,ts_s$V5)
		y_max<-max(t_sm_s$V5, t_gm_s$V5, i_gm_s$V5,i_sm_s$V5,
				b_s$V5,s_s$V5)
				#bs_s$V3,is_s$V5,ts_s$V5)

		plot(t_sm_s$V3, t_sm_s$V5, type="o",log="x",
			ylim=c(y_min,y_max),xlim=c(x_min,x_max),
			pch=1,col=1,
			bty="n",xlab="Index Size",ylab="Run Time (ms)",
			main="Binary Search, Database:1000000, Queries:500000" )
		lines(t_gm_s$V3, t_gm_s$V5, type="o" ,pch=2,col=2)
		lines(i_sm_s$V3, i_sm_s$V5, type="o" ,pch=3,col=3)
		lines(i_gm_s$V3, i_gm_s$V5, type="o" ,pch=4,col=4)
		lines(b_s$V3, b_s$V5, type="o" ,pch=5,col=5)
		lines(s_s$V3, s_s$V5, type="o" ,pch=6,col=6)
		#lines(bs_s$V3, bs_s$V5, type="o" ,pch=6,col=6)
		#lines(is_s$V3, is_s$V5, type="o" ,pch=7,col=7)
		#lines(ts_s$V3, ts_s$V5, type="o" ,pch=8,col=8)

		legend("topleft", c("Shared Mem Tree (9800 GT)",
							"Global Mem Tree (9800 GT)", 
							"Shared Mem List (9800 GT)",
							"Global Mem List (9800 GT)",
							"No Index (9800 GT)",
							"Sorted Queries, No Index (9800 GT)"),
			pch=1:6, col=1:6, bty="n", lty=1)

	}
}
dev.off()
