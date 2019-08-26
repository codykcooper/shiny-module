library(ShinyAvacado)

con = dbConnect(RSQLite::SQLite(), "Data/avocado.sqlite")
tbl_name = 'avocado'

df = tbl(con, tbl_name) %>% collect()

date_range = df %>%
  summarise(
    date_min = min(Date),
    date_max = max(Date)
  ) %>% collect()

date_range$date_min

