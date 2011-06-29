t_sm <- read.delim("t_sm_b_search_cuda.0.txt",header=F,sep=",")
t_gm <- read.delim("t_gm_b_search_cuda.0.txt",header=F,sep=",")
i_gm <- read.delim("i_gm_b_search_cuda.0.txt",header=F,sep=",")
i_sm <- read.delim("i_sm_b_search_cuda.0.txt",header=F,sep=",")
b <- read.delim("b_search_cuda.0.txt",header=F,sep=",")
s <- read.delim("sort_b_search_cuda.0.txt",header=F,sep=",")
s_t_gm <- read.delim("sort_t_gm_b_search_cuda.0.txt",header=F,sep=",")
#bs <- read.delim("b_search_seq.txt",header=F,sep=",")
#is <- read.delim("i_search_seq.txt",header=F,sep=",")
#ts <- read.delim("t_search_seq.txt",header=F,sep=",")

#d_s<-unique(t_sm$V1)
#q_s<-unique(t_sm$V2)


d_s = 1000000
q_s = 500000
#png("GTX285.png",width=1000)
for (d in d_s) {
	for (q in q_s) {
		t_sm_s<-subset(t_sm, V1==d & V2==q)
		t_gm_s<-subset(t_gm, V1==d & V2==q)
		i_gm_s<-subset(i_gm, V1==d & V2==q)
		i_sm_s<-subset(i_sm, V1==d & V2==q)
		b_s<-subset(b, V1==d & V2==q)
		s_s<-subset(s, V1==d & V2==q)
		s_t_gm_s<-subset(s_t_gm, V1==d & V2==q)
		#bs_s<-subset(bs, V1==d & V2==q)
		#is_s<-subset(is, V1==d & V2==q)
		#ts_s<-subset(ts, V1==d & V2==q)

		x_min<-min(t_sm_s$V3, t_gm_s$V3,i_gm_s$V3,i_sm_s$V3,
				b_s$V3,s_s$V3,s_t_gm_s$V3)
				#bs_s$V3,is_s$V3,ts_s$V3)
		x_max<-max(t_sm_s$V3, t_gm_s$V3, i_gm_s$V3,i_sm_s$V3,
				b_s$V3,s_s$V3,s_t_gm_s$V3)
				#bs_s$V3,is_s$V3,ts_s$V3)
		y_min<-min(t_sm_s$V5, t_gm_s$V5, i_gm_s$V5,i_sm_s$V5,
				b_s$V5,s_s$V5,s_t_gm_s$V5)
				#bs_s$V3,is_s$V5,ts_s$V5)
		y_max<-max(t_sm_s$V5, t_gm_s$V5, i_gm_s$V5,i_sm_s$V5,
				b_s$V5,s_s$V5,s_t_gm_s$V5)
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
		lines(s_t_gm_s$V3, s_t_gm_s$V5, type="o" ,pch=7,col=7)
		#lines(bs_s$V3, bs_s$V5, type="o" ,pch=6,col=6)
		#lines(is_s$V3, is_s$V5, type="o" ,pch=7,col=7)
		#lines(ts_s$V3, ts_s$V5, type="o" ,pch=8,col=8)

		legend("topleft", c("Shared Mem Tree (GTX 285)",
							"Global Mem Tree (GTX 285)", 
							"Shared Mem List (GTX 285)",
							"Global Mem List (GTX 285)",
							"No Index (GTX 285)",
							"Sorted, No Index (GTX 285)",
							"Sorted Global Mem Tree (GTX 285)"),
							#"No Index ",
							#"List",
							#"Tree"),
			pch=1:7, col=1:7, bty="n", lty=1)

	}
}
#dev.off()


