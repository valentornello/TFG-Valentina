# Calcular los GDU_MF (Siembra-Madurez fisiológica) y GDU_MC (Siembra-Madurez Comercial) acumulados desde la fecha de siembra
# Pergamino Campaña 2018-19 siembra temprana = 20/09/2018, siembra tardía = 10/12/2018

# Paquetes necesarios
library(readxl)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(openxlsx)
# Cargar archivo de clima 18-19
clima1819 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/CLIMA 1819.xlsx")
clima1819$Fecha <- as.Date(clima1819$Fecha, format = "%d/%m/%Y")
# Asegurarnos que las columnas sean numéricas con comas. Nombres: "GDU ACUMULADOS FECHA TEMPRANA" y "GDU ACUMULADOS FECHA TARDIA"   
#clima1819$GDU ACUMULADOS FECHA TEMPRANA <- gsub(",", ".", clima1819$GDU ACUMULADOS FECHA TEMPRANA)
#clima1819$'GDU ACUMULADOS FECHA TARDIA' <- gsub(",", ".", clima1819$'GDU ACUMULADOS FECHA TARDIA') NO FUNCIONA
clima1819$'GDU ACUMULADOS FECHA TEMPRANA' <- as.numeric(gsub(",", ".", clima1819$'GDU ACUMULADOS FECHA TEMPRANA'))
clima1819$'GDU ACUMULADOS FECHA TARDÍO' <- as.numeric(gsub(",", ".", clima1819$'GDU ACUMULADOS FECHA TARDÍO'))

# Cargar archivo con cálculos de fechas de MF y MC sin modificar el formato/colores de las tablas
excel1819 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/ENSAYO_2018-2019_PROCESADO.xlsx", sheet = "BLUP Base")
#MF y MC son fechas que varían por ensayo temprano y tardío y son específicas del plot.
MF <- as.Date(excel1819$MF, format = "%d/%m/%Y")
MC <- as.Date(excel1819$MC, format = "%d/%m/%Y")

# En clima1819 los GDU ya están acumulados desde cada fecha de siembra.
# MF y MC se usan como claves de búsqueda y la columna GDU depende de Ensayo.
calcular_gdu <- function(fecha_madurez, ensayo, clima) {
  columna_gdu <- if (ensayo == "Temprano") {
    "GDU ACUMULADOS FECHA TEMPRANA"
  } else if (ensayo == "Tardío") {
    "GDU ACUMULADOS FECHA TARDÍO"
  } else {
    return(NA_real_)
  }

  gdu <- clima %>%
    filter(Fecha == fecha_madurez) %>%
    pull(all_of(columna_gdu))

  if (length(gdu) == 0) NA_real_ else gdu[[1]]
}
# Agregar a cada fila los GDUs acumulados según las columnas MF y MC del archivo excel1819, usando la función calcular_gdu según Ensayo= Temprano/Tardío.
# Aplicar la función a cada fila del archivo excel1819 basándose en la columna Ensayo para determinar la fecha de siembra correspondiente (Temprano = 20/09/2018, Tardío = 10/12/2018) y calcular los GDU acumulados para MF y MC.
excel1819 <- excel1819 %>%
  rowwise() %>%
  mutate(Siembra = ifelse(Ensayo == "Temprano", as.Date("2018-09-20"), as.Date("2018-12-10"))) %>%
  ungroup()

excel1819 <- excel1819 %>%
  rowwise() %>%
  mutate(GDU_MF = calcular_gdu(MF, Ensayo, clima1819),
    GDU_MC = calcular_gdu(MC, Ensayo, clima1819)) %>%
  ungroup()
# Mostrar el resultado final con las nuevas columnas GDU_MF y GDU_MC

# Ver todas las columnas del dataframe excel1819 y los primeros 10 datos
print(excel1819, n = 10)  # Mostrar las primeras 10 filas para verificar

# Armar dataframe final con las columnas relevantes: Ensayo, Plot, Pedigree, MF, MC, GDU_MF, GDU_MC
dataframe_GDU_MF_MC <- excel1819 %>%
  select(Ensayo, PLOT, PEDIGREE, MF, MC, GDU_MF, GDU_MC)
dataframe_GDU_MF_MC

# Mostrar la tabla completa con pedigrees de Campaña 2018-19 (todas las variables)
dataframe_201819 <- excel1819 %>%
  select(Ensayo, PLOT, PEDIGREE, GDU_R1, GDU_VT, GDU_ASI, GDU_MF, GDU_MC)
dataframe_201819

# Ahora selecciona únicamente los genotipos en común entre las campañas 2015-16, 2016-17, 2017-18 y 2018-19 para poder hacer un análisis de correlación entre las campañas.
# Cargar archivo con datos de las campañas anteriores

# ---- Campaña 2015-2016 -----
# Localidad Pergamino, tres "zonas" --> consultar a codirector
per1_1516 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "PER1_1516")
per2_1516 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "PER2_1516")
per3_1516 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "PER3_1516")

# Localidad Marcoz Juárez (única repetición) --> preguntar utilidad a directores
mj_1516 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "MJ_1516")

# ---- Campaña 2016-2017 -----
# Localidad Pergamino, dos "zonas"/lotes, falta la zona 3 --> consultar a codirector
per1_1617 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "PER1_1617")
per2_1617 <- read_excel("C:/Users/valen/Escritorio/TFG Valentina/BASE DATOS 15-17.xlsx", sheet = "PER2_1617")

# Ahora selecciona únicamente los genotipos en común entre las campañas 2015-16, 2016-17 y 2018-19 para poder hacer un análisis de correlación entre las campañas.
genotipos_1516_pergamino <- unique(c(per1_1516$Pedigree, per2_1516$PedigreeP_2, per3_1516$Pedigree))
genotipos_1516_mj <- unique(mj_1516$Pedigree)
genotipos_1617 <- unique(c(per1_1617$PEDIGREE, per2_1617$PEDIGREE))
genotipos_1819 <- unique(excel1819$PEDIGREE)  

# Los miramos
genotipos_1516_pergamino
genotipos_1516_mj
genotipos_1617
genotipos_1819

# Genotipos en común entre las campañas 2015-16, 2016-17 y 2018-19 de Pergamino y Marcos Juárez
genotipos_comunes <- Reduce(intersect, list(genotipos_1516_pergamino, genotipos_1516_mj, genotipos_1617, genotipos_1819))
genotipos_comunes

# Genotipos en común entre las campañas 2015-16, 2016-17 y 2018-19 de Pergamino
genotipos_pergamino <- Reduce(intersect, list(genotipos_1516_pergamino, genotipos_1617, genotipos_1819))
genotipos_pergamino

# Reemplazar el archivo "Genotipos_Listados.xlsx" con los genotipos en común entre las campañas 2015-16, 2016-17 y 2018-19 de Pergamino y Marcos Juárez.
# Guardar en cada hoja: genotipos_comunes, genotipos_pergamino, genotipos_1516_pergamino, genotipos_1516_mj, genotipos_1617, genotipos_1819
# Crear una tabla que muestre el recuento de genotipos al final de cada hoja. 
genotipos_listados <- list(
  "Genotipos Comunes" = genotipos_comunes,
  "Genotipos Pergamino" = genotipos_pergamino,
  "Genotipos 15-16 Pergamino" = genotipos_1516_pergamino,
  "Genotipos 15-16 Marcos Juárez" = genotipos_1516_mj,
  "Genotipos 16-17" = genotipos_1617,
  "Genotipos 18-19" = genotipos_1819
)
# Dejar prolijo el excel, cada hoja con una columna "Pedigree", Número y con el recuento total de genotipos en cada hoja.
# Función para dejar una tabla en el excel en cada hoja con una columna "Número" y "Pedigree" y una fila con el total de genotipos en cada hoja.
recuento_genotipos <- function(genotipos) {
  df <- data.frame(Pedigree = genotipos)
  total_genotipos <- nrow(df)
  df <- rbind(df, c("Total Genotipos", total_genotipos))
  return(df)
}
recuento_genotipos(genotipos_comunes)
genotipos_listados_df <- lapply(genotipos_listados, function(x) recuento_genotipos(x))
write.xlsx(genotipos_listados_df, "C:/Users/valen/Escritorio/TFG Valentina/Genotipos_Listados.xlsx", rowNames = FALSE)


# Genotipos por campaña
genotipos_listados <- list(
  "Genotipos Comunes" = genotipos_comunes,
  "Genotipos Pergamino" = genotipos_pergamino,
  "Genotipos 15-16 Pergamino" = genotipos_1516_pergamino,
  "Genotipos 15-16 Marcos Juárez" = genotipos_1516_mj,
  "Genotipos 16-17" = genotipos_1617,
  "Genotipos 18-19" = genotipos_1819
)

# Preparar tablas
genotipos_listados_df <- lapply(names(genotipos_listados), function(nombre) {
  
  x <- trimws(na.omit(as.character(genotipos_listados[[nombre]])))
  
  campaña <- if (grepl("15-16", nombre)) "2015-16"
             else if (grepl("16-17", nombre)) "2016-17"
             else if (grepl("18-19", nombre)) "2018-19"
             else if (grepl("Pergamino", nombre)) "Pergamino"
             else if (grepl("Marcos Juárez", nombre)) "Marcos Juárez"
             else "Común"
  
  data.frame(
    Número = seq_along(x),
    Pedigree = x,
    Campaña = campaña
  )
})

names(genotipos_listados_df) <- names(genotipos_listados)

# Crear Excel
wb <- createWorkbook()

for (nombre in names(genotipos_listados_df)) {
  
  df <- genotipos_listados_df[[nombre]]
  addWorksheet(wb, nombre, gridLines = FALSE)
  
  writeDataTable(
    wb, nombre, df,
    startRow = 1,
    tableStyle = "TableStyleMedium2"
  )
  
  # Total
  fila <- nrow(df) + 3
  writeData(wb, nombre, "Total de genotipos", startRow = fila)
  writeData(wb, nombre, nrow(df), startRow = fila, startCol = 2)
  
  addStyle(
    wb, nombre,
    createStyle(textDecoration = "bold", fgFill = "#E8E8E8"),
    rows = fila, cols = 1:3, gridExpand = TRUE
  )
  
  setColWidths(wb, nombre, 1:3, c(10, "auto", 15))
  freezePane(wb, nombre, firstActiveRow = 2)
}

# Guardar Excel
saveWorkbook(
  wb,
  "C:/Users/valen/Escritorio/TFG Valentina/Genotipos_Listados.xlsx",
  overwrite = TRUE
)

# Armar una tabla final con los genotipos en común entre las campañas 2015-16, 2016-17 y 2018-19 de Pergamino y Marcos Juárez, incluyendo las variables relevantes de cada campaña (GDU_MF y GDU_MC) para poder hacer un análisis de correlación entre las campañas.
# Primero, unificar nombres de columnas para cada variable. GDU_R1 = S-R1, GDU_VT = S-VT, GDU_ASI, GDU_MF = S-MF, GDU_MC = S-MC. Agregar columna Campaña y Localidad.
# Cambiamos los de excel1819 
dataframe_201819 <- dataframe_201819 %>%
  rename(
     "ASI" = 'S-ASD'
  ) %>%
  mutate(Campaña = "2018-19", Localidad = "Pergamino")

dataframe_201819

# Ahora vamos armando el BLUP base con excel1819, per1_1516, per2_1516, per3_1516, mj_1516, per1_1617 y per2_1617.
# Juntamos todas las tablas en una misma.
BLUP_base <- bind_rows(
  dataframe_201819,
  per1_1516 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'Pedigree',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2015-16", Localidad = "Pergamino"),
  per2_1516 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'PedigreeP_2',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2015-16", Localidad = "Pergamino"),
  per3_1516 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'Pedigree',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2015-16", Localidad = "Pergamino"),
  mj_1516 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'Pedigree',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2015-16", Localidad = "Marcos Juárez"),
  per1_1617 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'Pedigree',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2016-17", Localidad = "Pergamino"),
  per2_1617 %>%
    rename(
      "Ensayo" = 'Ensayo',
      "PLOT" = 'PLOT',
      "PEDIGREE" = 'PedigreeP_2',
      "GDU_R1" = 'S-R1',
      "GDU_VT" = 'S-VT',
      "GDU_ASI" = 'ASI',
      "GDU_MF" = 'S-MF',
      "GDU_MC" = 'S-MC'
    ) %>%
    mutate(Campaña = "2016-17", Localidad = "Pergamino")
)

# Descargar tabla de GDUs ensayo2018-2019 en formato excel para agregarlos al excel original
write.xlsx(excel1819, "C:/Users/valen/Escritorio/TFG Valentina/GDUs_MF_MC_2018-19.xlsx", rowNames = FALSE)
library(tinytex)
# Guardar el pdf del Rmd Informe_GDU_MF_MC.Rmd
rmarkdown::render("Lógica MF y MC 2018-19.Rmd", output_format = "pdf_document")

# Detectar desvíos de madurez fisiológica (en días) entre los dos bloques del mismo pedigree
# Tiene que haber dos bloques para temprano y tardío en campañas 201819
# Tabla con los desvíos de madurez fisiológica (MF) y madurez comercial (MC)
# entre los dos bloques del mismo pedigree, agrupando por Ensayo y Pedigree.

# Crear una tabla con una fila por combinación Ensayo-Pedigree.
# El desvío se calcula como bloque 2 menos bloque 1, en días.
# Se conservan también los pedigrees que tienen un solo bloque.
desvios_madurez <- excel1819 %>%
  mutate(Bloque = as.character(BLOCK)) %>%
  arrange(Ensayo, PEDIGREE, Bloque) %>%
  group_by(Ensayo, PEDIGREE) %>%
  summarise(
    Bloque_1 = if ("1" %in% Bloque) "1" else "Ausente",
    Bloque_2 = if ("2" %in% Bloque) "2" else "Ausente",
    Desvio_MF_dias = if (n() == 2 && all(c("1", "2") %in% Bloque)) {
      as.numeric(MF[match("2", Bloque)] - MF[match("1", Bloque)])
    } else {
      NA_real_
    },
    Desvio_MC_dias = if (n() == 2 && all(c("1", "2") %in% Bloque)) {
      as.numeric(MC[match("2", Bloque)] - MC[match("1", Bloque)])
    } else {
      NA_real_
    },
    .groups = "drop"
  ) %>%
  arrange(Ensayo, PEDIGREE)
desvios_madurez

# Descargar tabla de desvíos de madurez fisiológica (MF) y madurez comercial (MC) entre los dos bloques del mismo pedigree en formato excel
write.xlsx(desvios_madurez, "C:/Users/valen/Escritorio/TFG Valentina/Desvios_MF_MC_2018-19.xlsx", rowNames = FALSE) 
