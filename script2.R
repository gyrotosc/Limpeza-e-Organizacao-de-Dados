install.packages("tidyverse")
library("tidyverse")
pl1 <- read.csv2("Base de dados/G_AND_E_Scopus_V17052021.csv")
pl2 <- read.csv2("Base de dados/G_AND_E_WOS_V17052021.csv")
#Retirando artigos sem ISSN de pl2
summary(is.na(pl2$ISSN))#103 artigos sem ISSN
pl2 <- filter(pl2, is.na(ISSN)==FALSE)#Remoção dos artigos sem ISSN
#Deixar o ISSN de pl2 no mesmo formato do pl1
pl2$ISSN <- gsub("-", "", pl2$ISSN)#Todos os ISSN estavam no formato
1234-567(8 ou X), retiramos o -
  for (i in 1:length(pl1$ISSN)){
    if(nchar(as.character(pl1$ISSN[i]))<8){
      pl1$ISSN[i] <- paste("0", pl1$ISSN[i], sep = "")
    }
  }#Precisei aplicar 3 vezes, pois haviam dados com apenas 5 dígitos
#Unir pl1 e pl2
plUnion <- merge(pl1, pl2, by = "Title", all.x = T, all.y = T)
str(a)
#a = artigos que estão em pl1 e pl2
a<-filter(plUnion, is.na(ISSN.x)==FALSE & is.na(ISSN.y) == FALSE)
#b = artigos que estão apenas em pl1
b<-filter(plUnion, is.na(ISSN.x)==FALSE & is.na(ISSN.y) == TRUE)
#c = artigos que estão apenas em pl2
c<-filter(plUnion, is.na(ISSN.x)==TRUE & is.na(ISSN.y) == FALSE)
#Eliminando duplicata de a e arrumando b e c (tirando as colunas
preenchidas com NAs)
a <- a[,1:13]
a$Source.x <- "Scopus; Web of Science"
b <- b[,1:13]
c <- c[, -(2:13)]
#Renomeando as colunas
colnames(a) <- c("Title","N.Article","Authors", "Year", "Document.Type",
                 "Source.Title", "Language", "Authors.Keywords",
                 "Abstract", "ISSN",
                 "Cited.by", "Publisher.Country", "Source")
colnames(b) <- c("Title","N.Article","Authors", "Year", "Document.Type",
                 "Source.Title", "Language", "Authors.Keywords",
                 "Abstract", "ISSN",
                 "Cited.by", "Publisher.Country", "Source")
colnames(c) <- c("Title","N.Article","Authors", "Year", "Document.Type",
                 "Source.Title", "Language", "Authors.Keywords",
                 "Abstract", "ISSN",
                 "Cited.by", "Publisher.Country", "Source")
#Unindo tudo num dataframe
a <- rbind(a, b, c)
#Removendo os artigos sem keywords
a <- a[!is.na(a$Authors.Keywords),]
a <- a[!a$Authors.Keywords == "",]
#Removendo artigos sem endereço (No Country)
a<- a[a$Publisher.Country != 0,]
#Exportando a planilha final
write.csv2(a, "G_AND_E_SCOPUS_AND_WOS_V20052021.csv")
#A planilha final "plFinal", segundo as exclusões feitas acima, foram
listados 1339 artigos (artigo e revisão) encontrados nos últimos 5 anos a
partir das keywords Gamification and Education