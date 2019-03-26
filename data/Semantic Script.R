# Required Packages
library(tm)
library(ggplot2)
library(lsa)
library(readr)
library(stringr)
library(plotly)

Sys.setlocale('LC_ALL','C')

# Load Text
Result <- data.frame(read_csv("https://raw.githubusercontent.com/gzrcm/Known_Unknowns/master/data/Result.csv"),stringsAsFactors=FALSE)

# Pre-Pre Process Text
Result$Text =str_replace_all(Result$Text,"[^[:graph:]]", " ") 
Result<-Result[!is.na(Result$Text),]
Result <- Result[ c("Classification","Document","Text") ]
Result$Text =str_replace_all(Result$Text,"[^[:graph:]]", " ") 
Result<-Result[!is.na(Result$Text),]
Result <- Result[ c("Classification","Document","Text") ]

# Build a Corpus
corpus <- Corpus(VectorSource(Result$Text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))
corpus <- tm_map(corpus, stemDocument, language = "english")
corpus # check corpus

# Create a Distance Matrix
td.mat <- as.matrix(TermDocumentMatrix(corpus))

# Multidimensional Scaling with Latent Semantic Analaysis
td.mat.lsa <- lw_bintf(td.mat) * gw_gfidf(td.mat) # weighting
lsaSpace <- lsa(td.mat.lsa) # create LSA space
dist.mat.lsa <- dist(t(as.textmatrix(lsaSpace))) # compute distance matrix
head(dist.mat.lsa,100) # check distance mantrix

# Classic Multi-Dimensional Scaling for Graphing
fit <- cmdscale(dist.mat.lsa, eig=TRUE, k=2)
points <- data.frame(x=fit$points[, 1], y=fit$points[, 2])
full<-data.frame(cbind(Result,points))
full<-full %>% filter(x >=-100) %>%filter(y >=-100)

# Classic Multi-Dimensional Scaling for Graphing
ggplotly(ggplot(full,aes(x=x, y=y)) +
           theme_bw()+
           geom_point(data=full[1,],aes(x=x, y=y),size=2.5,color="#FF0000", shape=5) +
           geom_point(data=full,aes(x=x, y=y, color=full$Classification)) +
           theme(legend.title=element_blank())+
           xlab("Dimension 1") + 
           ylab("Dimension 2") +
           guides(guide_legend(title="Document Classification")) +
           geom_text(data=full,aes(x=x, y=y-0.2, label=row.names(full)))+
           stat_ellipse(aes(x=x, y=y,color=full$Classification),type="norm",level = 0.95))%>% config(displayModeBar = F, autosize=T)