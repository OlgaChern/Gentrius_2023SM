#--------------------------------------------------------------------------------------------------
#
#	DESCRIPTION
#
#--------------------------------------------------------------------------------------------------
# This script plots an input tree with the information about its resolution. 
#
# RESOLUTION SUMMARY:
# - Multifurcation nodes: external/internal nodes are indicated by blue/red nodes with a node degree
# - N: a number provided by the user (e.g. the number of trees an input consensus tree is built from)
# - R: tree resolution, i.e. the % of internal branches out of n-3 internal branches on fully resolved bifurcating tree
# - iB: number of internal branches on the tree
# - mN: number of multifurcating nodes (blue and red nodes)
#
#--------------------------------------------------------------------------------------------------
#
# INFO: Multifurcating nodes (i.e. nodes with node degree > 3).
# Two types of multifurcating nodes are distinguished:
# - external nodes: incident to a single internal branch, the rest lead to tree tips
# - internal nodes: incident to at least two internal branches
#
#--------------------------------------------------------------------------------------------------
#
# The input tree should be in Newick format. By default script provides visualisation with 
# unrooted tree shape and without tips. To change it use options, described in USAGE below.
#
#--------------------------------------------------------------------------------------------------
# IMPORTANT: Make sure you installed all required R libraries, described below.
#--------------------------------------------------------------------------------------------------
#
#	CITATION
#
#--------------------------------------------------------------------------------------------------
# If you use this script, please cite corresponding article.
# Chernomor et al. "Identifying equally scoring species-trees in phylogenomics with incomplete data using Gentrius"
#--------------------------------------------------------------------------------------------------
#
#	USAGE
#
#--------------------------------------------------------------------------------------------------
# Mandatory parameter: <tree_file>
# Rscript script-plot-tree-with-marked-multifurcations.r <tree_file> 
#--------------------------------------------------------------------------------------------------
# Additional parameters:
# Rscript script-plot-tree-with-marked-multifurcations.r <tree_file> <tree_style> <show_tip_labels> <num>
#
# - tree_style:		u - unrooted, c - cladigram, r - round, f - fan
# - show_tip_labels:	T or F, for TRUE/FALSE (Note: only cladogram was optimised to show tips "nicely")
# - num: integer value (This value could be use, for instance, for consensus trees, to specify the number of trees it was built from)
#--------------------------------------------------------------------------------------------------
#
#	TIPS
#
#--------------------------------------------------------------------------------------------------
# There are a number of parameters (tips position, node size etc.) that might be useful to tune 
# visualisation for user-specific needs and tastes. Search for keyword: ADJUSTABLE
#--------------------------------------------------------------------------------------------------
#
#	LIBRARIES/REQUIREMENTS
#
#--------------------------------------------------------------------------------------------------
library(ape)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(stringr)
#--------------------------------------------------------------------------------------------------
#
#	ARGUMENTS PARSING
#
#--------------------------------------------------------------------------------------------------
args = commandArgs(trailingOnly=TRUE)
#--------------------------------------------------------------------------------------------------
file=args[1]
#--------------------------------------------------------------------------------------------------
# defaults:
tree_shape="u"		# unrooted tree
show_tips="F"		# without tips
TreeNUM="not supplied"
#--------------------------------------------------------------------------------------------------
if(length(args)>1){
    tree_shape=args[2]  # u - unrooted, c - cladigram, r - round, f -fan
    if(length(args)>2){
        show_tips=args[3]   # T for true
        if(show_tips=="t" || show_tips=="T" || show_tips=="TRUE" || show_tips=="true"){
            show_tips="T"
            if(tree_shape!="c"){
                print("Only cladogram is optimised to display trees with tips names! Changing tree shape to cladogram..")
                tree_shape="c"
            }
        }
    }
	if(length(args)>3){
        TreeNUM=args[4]
	}
}
#--------------------------------------------------------------------------------------------------
#
#	FUNCTIONs
#
#--------------------------------------------------------------------------------------------------
plot_layout_ape_style <- function(tree, type, show_tip_names=FALSE) {
    
    node_depth=1
    if(show_tip_names & type=="c"){
        node_depth=2
    }
    
    plot.phylo(tree, type = type,show.tip.label=show_tip_names, plot=FALSE,node.depth=node_depth,node.pos=1,use.edge.length=FALSE)
    info=get("last_plot.phylo",envir=.PlotPhyloEnv)
    
    edges=tibble(
        V1=info$edge[,1],
        V2=info$edge[,2],
        X1=info$xx[info$edge[,1]],
        X2=info$xx[info$edge[,2]],
        Y1=info$yy[info$edge[,1]],
        Y2=info$yy[info$edge[,2]]
        )
        
    degrees=tibble(id=c(edges$V1,edges$V2))%>%group_by(id)%>%summarise(deg=n())
    coords=union(
        edges%>%select(V1,X1,Y1)%>%transmute(id=V1,X=X1,Y=Y1),
        edges%>%select(V2,X2,Y2)%>%transmute(id=V2,X=X2,Y=Y2)
        )
        
    internal_multi_nodes=tibble(id=c(edges$V1,edges$V2),other_side=c(edges$V2,edges$V1))%>%
        left_join(degrees,by="id")%>%rename(multi_node=id)%>%rename(id=other_side)%>%rename(multi_deg=deg)%>%
        left_join(degrees,by="id")%>%rename(nei=id,nei_deg=deg)%>%
        filter(multi_deg>3,nei_deg>1)%>%
        group_by(multi_node)%>%summarise(num_int_incident=n())%>%
        filter(num_int_incident>1)
  
    v=tibble(
        id=1:(info$Ntip+info$Nnode),
        label=c(tree$tip.label,rep("",info$Nnode))
        )
        
    #--------------------------------------------------------------------------
    # ADJUSTABLE: here you can change the properties of nodes and edge width
    #--------------------------------------------------------------------------
    
    node_size_bifurcating=0.1
    node_size_multifurcating=2

    node_col_tips="black"
    node_col_bifurcating="darkgrey"
    node_col_multifurcating_external="royalblue"
    node_col_multifurcating_internal="#D93951"

    edge_size=0.5
    
    #--------------------------------------------------------------------------
    
    vertices=v%>%full_join(degrees,by=c("id"))%>%
        mutate(sz=ifelse(deg>3,node_size_multifurcating,node_size_bifurcating))%>%
        mutate(col=ifelse(deg>3,node_col_multifurcating_external,node_col_bifurcating))%>%
        mutate(sz=ifelse(deg==1,node_size_bifurcating,sz),col=ifelse(deg==1,node_col_tips,col))%>%
        full_join(coords,by=c("id"))
    
    if(nrow(internal_multi_nodes)>0){
        vertices=vertices%>%mutate(col=ifelse(id %in% internal_multi_nodes$multi_node,node_col_multifurcating_internal,col))
    }
    
    df_tips=vertices%>%filter(id<=info$Ntip)%>%mutate(label=str_replace_all(label, "_", " "))
    
    xlim_eps=1
    ylim_eps=0
    if(show_tip_names){
        xlim_eps=1.7
        ylim_eps
    }

    t=ggplot() +
        geom_segment(aes(x=X1,y=Y1,xend=X2,yend=Y2),data=edges,size=edge_size,colour="grey")+
        geom_point(aes(X,Y), data=vertices,colour="black",fill=vertices$col,size=vertices$sz,shape=21)+
        theme(
            axis.ticks.length = unit(0.000, "mm"),
            axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            legend.position="none"
            )+
        labs(x=NULL, y=NULL)+
        xlim(c(min(vertices$X),max(vertices$X)*xlim_eps))+
        ylim(c(min(vertices$Y)-1*ylim_eps,max(vertices$Y)+1*ylim_eps))+
        theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
    
    df_labels_degrees=vertices%>%filter(deg>3)%>%mutate(label_deg=deg)
    
    # -----------------------------------------------------------------------------
    # Add tip names to the plot
    #------------------------------------------------------------------------------
    if(show_tip_names){
    	#--------------------------------------------------------------------------
    	# ADJUSTABLE: here, you can change tip names position
    	#--------------------------------------------------------------------------
        # default:
    	size_tip=2
        x_shift=0.2

        # example:
        #size_tip=1
        #x_shift=0.3
        #--------------------------------------------------------------------------
        t=t+geom_text(
                data=df_tips,
                x=df_tips$X+x_shift,
                y=df_tips$Y,
                label=df_tips$label,
                check_overlap = TRUE,
                size = size_tip,
                hjust = 0,
                nudge_x = 0
                )+
            theme(
                panel.grid.major=element_blank(),
                panel.grid.minor=element_blank()
                )
    }
    
    #--------------------------------------------------------------------------
    # ADJUSTABLE: here, you can change node degree label size and repel
    #--------------------------------------------------------------------------
    node_degree_repel=ifelse(show_tip_names,FALSE,TRUE)
    size_label=ifelse(show_tip_names,3,5)
    #--------------------------------------------------------------------------
    if(node_degree_repel){
        t=t+geom_label_repel(
            aes(x=X,y=Y),
            data=df_labels_degrees,
            label = df_labels_degrees$label_deg,
            color=df_labels_degrees$col,
            box.padding = 1.2,
            size=size_label
            )
    }else{
        t=t+geom_label(
            aes(x=X,y=Y),
            data=df_labels_degrees,
            label=df_labels_degrees$label_deg,
            color=df_labels_degrees$col,
            size=size_label
            )
    }
    
    # compute the number of multifurcating nodes
    multi_NUM=vertices%>%filter(deg>3)%>%summarise(n=n())
    
    # return the tree plot and the number of multifurcating nodes
    return(list(tplot=t,Nmulti=multi_NUM$n))
}


#==================================================================================================
#
#	MAIN CODE:
#
#==================================================================================================
# Creating a tree object 
tree<-read.tree(file)           # read tree (in Newick format)
n=Ntip(tree)                    # number of tips/leaves/species
max_multi_node=Nnode(tree)      # number of internal nodes
internal_br_NUM=Nedge(tree)-n   # number of internal edges
#--------------------------------------------------------------------------------------------------
# PREPARING TREE PLOT
type=tree_shape
tinfo=plot_layout_ape_style(tree, type, show_tip_names=ifelse(show_tips=="T",TRUE,FALSE))
#-----------------------------------------------------------------------------------
# SUMMARY of TREE RESOLUTION
#-----------------------------------------------------------------------------------
multi_NUM=tinfo$Nmulti

x=c(1,2,3,4)
y=2

info_cols=c(ifelse(TreeNUM!="not supplied","black","transparent"),rep("black",3))
info_labs=c(
    paste0("N: ",ifelse(TreeNUM!="not supplied",TreeNUM,"")),
    paste0("R: ",round(internal_br_NUM/(n-3)*100,0),"%",sep=""),
    paste0("iB: ",internal_br_NUM),
    paste0("mN: ",multi_NUM)
)

if(TreeNUM=="not supplied"){
    x=x[1:3]
    info_cols=info_cols[2:4]
    info_labs=info_labs[2:4]
}

df_labels=data.frame(X1=x,Y1=y,col=info_cols,lab=info_labs)
#-----------------------------------------------------------------------------------
sz=5
scale_x=c(0.7,ifelse(TreeNUM!="not supplied",4.3,3.3))

info<-ggplot() + theme_void() +
    scale_x_continuous(limits=scale_x)+
    geom_label(
        aes(x=df_labels$X1, y=df_labels$Y1),
        label=df_labels$lab,
        color=df_labels$col,size=sz,
        label.padding = unit(0.25,"lines"),
        label.r = unit(0.15, "lines"),
        label.size = 0.25
        )
#-----------------------------------------------------------------------------------
# OUTPUT PLOT size
#-----------------------------------------------------------------------------------
file_out=paste0(file,"-plot-",tree_shape)

w=4.2
h=4.8
heights=c(7,1)

if(show_tips=="T"){
    h=25
    w=5
    heights=c(25,1)
    
    if(n>500){
        h=50
        w=7
    }else if(n<300){
        h=15
    }
        
    file_out=paste0(file_out,"-with_tips")
}
#----------------------------------------------------------------------------------
# PLOT with summary information
#----------------------------------------------------------------------------------

pdf(paste0(file_out,"-summary.pdf"),w=w,h=h)
    gridExtra::grid.arrange(tinfo$tplot,info,ncol=1,nrow=2,heights=heights)
dev.off()

#----------------------------------------------------------------------------------
# PLOT only with the tree
#----------------------------------------------------------------------------------

w=ifelse(show_tips,w,4)
h=ifelse(show_tips,h,4)

pdf(paste0(file_out,".pdf"),w=w,h=h)
    tinfo$tplot
dev.off()

#----------------------------------------------------------------------------------
