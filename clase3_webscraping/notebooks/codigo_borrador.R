library(rvest)
library(tidyverse)

### CAJA NEGRA

caja_negra <- read_html("https://cajanegraeditora.com.ar/autores/")

autores_links <- caja_negra %>% html_elements(".field-name-title-field")%>% 
        html_elements("a")%>% 
        html_attr("href")

autores_nombres <- caja_negra %>% html_elements(".field-name-title-field") %>%
        html_text2()

autores_links <- paste0("https://cajanegraeditora.com.ar", autores_links)

autor <- read_html("https://cajanegraeditora.com.ar/autores/mark-fisher")

titulos <- autor %>% html_elements("h2") %>% html_text2()

precios <- autor %>% html_elements(".price") %>% html_text2()

disponibilidad <- autor %>% html_elements("a.product_type_simple") %>% html_text2()

### ANAGRAMA
piglia <- read_html("https://www.anagrama-ed.es/autor/piglia-ricardo-856")

libros <- piglia %>% html_elements(".libro-vertical__info")%>% 
        html_elements("a")%>% 
        html_attr("href")

libros_links <- paste0("https://www.anagrama-ed.es", libros)

libros_links <- libros_links[1:3]

df <- data.frame()
titulos <- c()
resumenes <- c()
info_extra <- data.frame(isbn = numeric(), ean  = numeric(), precio = character(), 
                         paginas  = numeric(), fecha_publicacion = character())

for (l in libros_links){
        
        libro <- read_html(l)
        
        titulo <- libro %>% html_elements("h1.titulo-libro") %>% 
                html_text2()
        
        titulos <- append(titulos, titulo)
        
        resumen <- libro %>% html_element(".textContent")%>%
                html_text()%>%
                str_squish()%>%
                str_replace("Título descatalogado.", "")
        
        resumenes <- append(resumenes, resumen)
        
        tabla_info <- libro %>% 
                html_element("table.no-print") %>% 
                html_table() 
        
        tabla_info <- tabla_info%>%
                pivot_wider(names_from = "X1", values_from = "X2") %>%
                rename("isbn" = "ISBN",
                       "ean" = "EAN",
                       "precio" = "PVP CON IVA",
                       "paginas" = "NÚM. DE PÁGINAS",
                       "fecha_publicacion" = "PUBLICACIÓN") %>%
                select(isbn, ean, precio, paginas, fecha_publicacion)
        
        info_extra <- rbind(info_extra, tabla_info)
        
}

info_extra <- info_extra%>%
        pivot_wider(names_from = "X1", values_from = "X2") %>%
        rename("isbn" = "ISBN",
               "ean" = "EAN",
               "precio" = "PVP CON IVA",
               "paginas" = "NÚM. DE PÁGINAS",
               "fecha_publicacion" = "PUBLICACIÓN") %>%
        select(isbn, ean, precio, paginas, fecha_publicacion)


df <- data.frame(cbind(titulos, resumenes, info_extra))

libro <- read_html("https://www.anagrama-ed.es/libro/compactos/la-habitacion-cerrada/9788433914781/CM_147")

libro %>% html_elements("h1.titulo-libro") %>% 
        html_text2()

titulo <- libro %>% html_elements("h1.titulo-libro") %>% 
        html_text2()

autor <- libro %>% html_element(".t24px")%>%
        html_text()%>%
        str_squish()

sinopsis <- libro %>% html_element(".textContent")%>%
        html_text()%>%
        str_squish()%>%
        str_replace("Título descatalogado.", "")

tabla_info <- libro %>% 
        html_element("table.no-print") %>% 
        html_table() 

tabla_info <- tabla_info%>%
        pivot_wider(names_from = "X1", values_from = "X2")
