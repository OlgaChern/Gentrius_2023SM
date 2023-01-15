#-------------------------------------------------------------------------
# This script plots 0-1 matrix
# Usage:
# Rscript script-plot-matrix.r <0_1_matrix_file>
# If you use this script, please cite corresponding article.
# Chernomor et al. "Identifying equally scoring species-trees in phylogenomics with incomplete data using Gentrius"
#-------------------------------------------------------------------------
# The script provides two plots:
# 1. the order of rows and columns of input matrix are fixed			(file ext: <*reorder_FALSE.pdf>)
# 2. the rows and columns are reordered according to their row/column sums	(file ext: <*reorder_TRUE.pdf>)
#
# Colors: 
# - rows with row sum > 1:	1 - black,	0 - grey
# - rows with row sum = 1:	1 - red,	0 - pale pink
#
#-------------------------------------------------------------------------
reorder_columns<-function(m){

        n=nrow(m)
        k=ncol(m)
        cov=array(-1,k)
        for(j in 1:k){
                cov[j]=sum(m[,j])
        }

        new_order=c()
        while(length(which(cov[]==-1))!=k){
                max=max(cov)
                ids=which(cov[]==max)
                new_order=c(new_order,ids)
                for(i in ids){
                        cov[i]=-1
                }
        }

        new_m=matrix(-1,nrow=n,ncol=k)
        for(j in 1:length(new_order)){
                new_m[,j]=m[,new_order[j]]
        }
        return(new_m)
}



plot_one_matrix<-function(m,tag_order,n,k){
        
        if(tag_order==TRUE){
                a=reorder_columns(m)
                b=reorder_columns(t(a))
                m=t(b)
        }
        num=2
        colors=colorRampPalette(c("lightgrey","black"))
        for(i in 1:n){
                if(sum(m[i,])==1){
                        id=which(m[i,]==1)
                        m[i,]=rep(3,k)
                        m[i,id]=2
                        num=4
                        colors=colorRampPalette(c("lightgrey","black","firebrick","#cfa9a9"))
                }
        }
        image(t(m[n:1,]), col=colors(num),axes = FALSE,xlab="",ylab="")
}
#============================================================================================
#============================================================================================
#   ARGUMENTS
#============================================================================================
#============================================================================================
args = commandArgs(trailingOnly=TRUE)
file_in=args[1]         # matrix file


cell=1

tag_order_all=c("FALSE","TRUE")
for(tag_order in tag_order_all){
    if(file.exists(file_in)){
        m=read.table(file_in,skip=1,row.names=1)
        m=as.matrix(m)
        
        n=nrow(m)
        k=ncol(m)
        eps=ifelse(n/k>50,5,1)
        
        pdf(paste(file_in,"-plot_matrix-reorder_",tag_order,".pdf",sep=""),width=k*eps*cell,height=n*cell)
            par(mar=c(0,0,0,0),oma=c(0,0,0,0))
            plot_one_matrix(m,tag_order,n,k)
            dev.off()
    }else{
        print(paste("File not found:",file_in))
    }
}
