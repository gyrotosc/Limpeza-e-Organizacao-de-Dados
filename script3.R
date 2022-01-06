library("tidyverse")
pl1 <- read.csv2("Base de dados/G_AND_E_SCOPUS_AND_WOS_V20052021.csv")
summary(as.factor(pl1$Document.Type))
#Proceedings paper são artigos que foram publicados em revistas a partir de
eventos. Trataremos como artigos.
pl1$Document.Type <- gsub("Article; Proceedings Paper", "Article",
                          pl1$Document.Type)
#Separar as palavras presentes em pl1$Authors.Keywords
a <- strsplit(pl1$Authors.Keywords, ";")
a <- unlist(a)
a <- tolower(a)
#ajeitando as palavras chaves para sumarizar
a <- gsub("\\s", "", a)
a <- gsub("-", "", a)
a <- gsub("games", "game", a)
a <- gsub("studentengagement", "engagement", a)
summary(as.factor(a))
write.csv2(a, "listaKeywords.csv")
#Localizando artigos que possuem "engagement" nas palavras chaves e no
título
b <- grep("engagement", pl1$Authors.Keywords, ignore.case = T)
artigosEngagement <- pl1[b,]
c <- grep("engagement", artigosEngagement$Title, ignore.case = T)
artigosEngagement <- artigosEngagement[c,]
#analisando
summary(as.factor(artigosEngagement$Year))
summary(as.factor(artigosEngagement$Authors.Keywords))
#Separar as palavras presentes em pl1$Authors.Keywords
d <- strsplit(artigosEngagement$Authors.Keywords, ";")
d <- unlist(d)
d <- tolower(d)
#Ajeitando palavras-chaves pra sumarizar em artigosEngagement
d <- gsub("\\s", "", d)
d <- gsub("-", "", d)
d <- gsub("games", "game", d)
d <- gsub("studentengagement", "engagement", d)