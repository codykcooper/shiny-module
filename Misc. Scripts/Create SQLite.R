library(dplyr)
library(readr)
library(DBI)

df_avacado = read.csv("Data/avocado.csv")
df_avacado$X = NULL
df_avacado$year = NULL
names(df_avacado)

con <- dbConnect(RSQLite::SQLite(), "Data/avocado.sqlite")
dbWriteTable(con, "avocado", df_avacado, overwrite = T)

sql_test = tbl(con,'avocado') %>% collect()
names(sql_test)
