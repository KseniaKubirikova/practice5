#загрузка пакетов
library('data.table')
library('WDI')
library('leaflet')
suppressPackageStartupMessages(library('googleVis'))

#Интерактивная картограмма
indicator.code <- 'SH.IMM.IDPT'
DT <- data.table(WDI(indicator = indicator.code, start = 2017, end = 2017))

# все коды стран iso2
fileURL <- 'https://pkgstore.datahub.io/core/country-list/data_csv/data/d7c9d7cfb42cb69f4422dec222dbbaa8/data_csv.csv'
all.iso2.country.codes <- read.csv(fileURL, stringsAsFactors = F, 
                                   na.strings = '.')

# убираем макрорегионы
DT <- na.omit(DT[iso2c %in% all.iso2.country.codes$Code, ])

# объект: таблица исходных данных
g.tbl <- gvisTable(data = DT[, -'year'],
                   options = list(width = 300, height = 400))
# объект: интерактивная карта
g.chart <- gvisGeoChart(data = DT, 
                        locationvar = 'iso2c', 
                        hovervar = 'country',
                        colorvar = indicator.code, 
                        options = list(width = 500, 
                                       height = 400, 
                                       dataMode = 'regions'))
# размещаем таблицу и карту на одной панели (слева направо)
TG <- gvisMerge(g.tbl, g.chart,
                horizontal = TRUE,
                tableOptions = 'bgcolor=\"#CCCCCC\" cellspacing=10')
TG

# картинка-логотип для маркеров объекта
fileURL <- 'https://github.com/aksyuk/R-data/raw/master/pics/pharmacy-icon.png'
pharm.icon <- makeIcon(iconUrl = fileURL,
                       iconWidth = 31,
                       iconHeight = 31,
                       iconAnchorX = 31,
                       iconAnchorY = 31)
file.URL <- 'https://raw.githubusercontent.com/KseniaKubirikova/practice5/master/Krasnodar_1.csv'
download.file(file.URL, destfile = 'Krasnodar_1.csv')
df <- data.table(read.csv('Krasnodar_1.csv', 
                          stringsAsFactors = F))
df$lat <- as.numeric(df$lat)
df$long <- as.numeric(df$long)

# подписи к объектам с гиперссылками
map.sites <- paste0(df$address, '</em>')
# создаём виджет с картой
myMap <- df %>% leaflet(width = 800, height = 800) %>%
  addTiles() %>% addMarkers(icon = pharm.icon, popup = map.sites)
# рисуем карту
myMap



