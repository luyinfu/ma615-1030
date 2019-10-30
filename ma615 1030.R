library(RSQLite)
library(dplyr)
library(tidyr)
library(magrittr)

MA_donor_direct <- readxl::read_excel("/Users/tsuyu/Downloads/workspace/615/topMAdonors.xlsx",
                              sheet = "Direct Contributions & JFC Dist")
MA_donor_2 <- readxl::read_excel("/Users/tsuyu/Downloads/workspace/615/topMAdonors.xlsx",
                                 sheet = "JFC Contributions (DO NOT SUM W")
#MA_donor_direct %<>% filter(amount>=0)


contributor1 <- MA_donor_direct %>% 
  dplyr::select(contrib, lastname, contribid, fam, Zip, Fecoccemp, orgname, ultorg, amount) %>% 
  distinct()
#contributor_employer <- MA_donor_direct %>% 
 # dplyr::select(Fecoccemp, orgname, ultorg) %>% distinct()
contributor_zip1 <- MA_donor_direct %>% 
  dplyr::select(Zip, City, State) %>% distinct()
recipient1 <- MA_donor_direct %>% 
  dplyr::select(recipient, recipid, recipcode, party) %>% distinct()
donation1 <- MA_donor_direct %>% 
  dplyr::select(fectransid, date, contrib, recipient, cmteid, cycle) %>% distinct()

# MA_donor_direct$Zip
# length(unique(MA_donor_direct$fectransid))
# length(unique(MA_donor_direct$cmteid))


#for the second spreadsheet
contributor2 <- MA_donor_2 %>% 
  dplyr::select(contrib, lastname, contribid, fam, Zip, Fecoccemp, orgname, ultorg, amount) %>% 
  distinct()
contributor_zip2 <- MA_donor_2 %>% 
  dplyr::select(Zip, City, State) %>% distinct()
recipient2 <- MA_donor_direct %>% 
  dplyr::select(recipient, recipid, recipcode, party) %>% distinct()
donation2 <- MA_donor_direct %>% 
  dplyr::select(fectransid, date, contrib, recipient, cmteid, cycle) %>% distinct()



contributor <- rbind(contributor1, contributor2)
contributor_zip <- rbind(contributor_zip1,contributor_zip2)
recipient <- rbind(recipient1,recipient2)
donation <- rbind(donation1,donation2)

MA_donor <- dbConnect(SQLite(), "/Users/tsuyu/Downloads/workspace/MA_donor.db")
dbWriteTable(conn = MA_donor, value = contributor, name = "contributor")
dbWriteTable(conn = MA_donor, value = contributor_zip, name = "contributor_zip")
dbWriteTable(conn = MA_donor, value = recipient, name = "recipient")
dbWriteTable(conn = MA_donor, value = donation, name = "donation")
