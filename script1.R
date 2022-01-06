getwd()
search()
library(readxl)
library(plyr)
library(dplyr)
library(readr)
pl1 <- read.csv2("Base de dados/GamificationEducation_Scopus_Vfinal.csv")
#pl1 não consta nome dos autores e nem paises dos Publishers
pl2 <- read.csv2("Base de dados/
GamificationEducation_WebOfScience_Vfinal.csv")
pl3 <- read.csv2("Base de dados/scopus.csv")
#pl3 contém os autores para serem inseridos em pl1
pl4 <- read_excel("Base de dados/scopusCountries.xlsx")
#pl4 possui o endereço (paises) dos Publishers de pl1
pl5 <- read_excel("Base de dados/listCountries.xlsx")
#Lista de paises (Planilha de apoio)
#Ajeitando a pl3 para inseri-lá na pl1
for (i in 1:836){
  a = strsplit(pl3[i,2], "[||||]")#O Espaço delimitado por ||||
  pl3[i,2] <- a[1]
}
#Ajeitando a pl4 para inserí-la na pl1
pl4Teste <- pl4#Por segurança, aplicar em objeto teste
pl4Teste$Country <- 0#Criando coluna que será usada (preenchida toda com 0)
vectorCountries <- as.vector(pl5$Country)#Lista com nome dos paises
vectorCountries[187] <- "United States"#Antes era "United States of
America"
vectorCountries[45] <- "Czech Republic"
vectorCountries[196] <- "Taiwan"
vectorCountries[197] <- "Hong Kong"
for(i in 1:length(vectorCountries)){
 for(j in 1:nrow(pl4)){
 if(grepl(vectorCountries[i], pl4[j,])==TRUE){
 pl4Teste$Country[j] <- vectorCountries[i]
 }
 }
}
pl4Teste$Country[24] <- "Spain"
pl4Teste$Country[190] <- "Slovenia"
pl4Teste$Country[270] <- "United States"
pl4Teste$Country[674] <- "United States"
pl4Teste$Country <- as.factor(pl4Teste$Country)
#Completando pl1
pl1$Authors <- pl3[,2]#Inserindo autores
pl1$Publisher.Country <- pl4Teste$Country#Inseridos país onde foi publicado
#Selecionando as colunas de pl1
pl1 <- select(pl1, Title, Authors, Year, Document.Type, Source.title,
Language.of.Original.Document, Author.Keywords, Abstract, ISSN, Cited.by,
Publisher.Country)
pl1$Source <- "Scopus"
#Ajeitando pl2
#Inserindo paises das publicações
pl2Teste <- pl2
pl2Teste$Country <- 0
vectorCountriesV2 <- vectorCountries
vectorCountriesV2[187] <- "USA"#Específico para essa busca
vectorCountriesV2[186] <- "ENGLAND"
vectorCountriesV2[198] <- "UNITED STATES"
vectorCountriesV2[199] <- "Scotland"
for(i in 1:length(vectorCountriesV2)){
 for(j in 1:nrow(pl2Teste)){
 if(grepl(vectorCountriesV2[i], pl2Teste$Publisher.Address[j], T)==TRUE)
{
 pl2Teste$Country[j] <- vectorCountriesV2[i]
 }
 }
}
pl2Teste$Country <- as.factor(pl2Teste$Country)
#Inserindo a coluna Country na pl2
pl2$Country <- pl2Teste$Country
#Selecionando as colunas
pl2 <- select(pl2, Article.Title, Authors, Publication.Year, DocumentType,
Source.Title, Language, Author.Keywords, Abstract, ISSN,
Times.Cited..All.Databases, Country)
pl2$Source <- "Web of Science"#Inserindo coluna informando que foi
encontrado no web of science
#Deixando as colunas com o mesmo nome
colnames(pl1) <- c("Title","Authors", "Year", "Document.Type",
"Source.Title", "Language", "Authors.Keywords", "Abstract", "ISSN",
"Cited.by", "Publisher.Country", "Source")
colnames(pl2) <- c("Title","Authors", "Year", "Document.Type",
"Source.Title", "Language", "Authors.Keywords", "Abstract", "ISSN",
"Cited.by", "Publisher.Country", "Source")
glimpse(pl1)
glimpse(pl2)
#Exportando as planilhas
write.csv2(pl1, "G_and_E_Scopus_V17052021.csv")
write.csv2(pl2, "G_and_E_WOS_V17052021.csv")