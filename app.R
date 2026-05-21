#################################################
###### Universidad Continental ##################
###### Maestría en Economía #####################
# =============================================
####### PRODUCTO ACADÉMICO COLABORATIVO ########
###### CREACIÓN DE UN DASHBOARD INTERACTIVO #####
# Curso : Herramientas Informáticas I
# Docente : Joel Jovani Turco Quinto
# Tema : Dashboard Global Gapminder
# Objetivo : Analizar el PBI per cápita, la esperanza de vida
#            y la población a nivel mundial mediante visualizaciones
#            interactivas en R Shiny.
# =============================================

## Limpiar entorno
rm(list = ls())

# 1. INSTALAR Y CARGAR PAQUETES ----------------------------

paquetes <- c(
  "shiny", "shinydashboard", "ggplot2", "gapminder",
  "dplyr", "plotly", "DT", "maps", "viridis",
  "stringr", "scales"
)

instalar <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]

if(length(instalar) > 0){
  install.packages(instalar)
}

library(shiny)
library(shinydashboard)
library(ggplot2)
library(gapminder)
library(dplyr)
library(plotly)
library(DT)
library(maps)
library(viridis)
library(stringr)
library(scales)

# 2. PREPARACIÓN DE DATOS ----------------------------------

DATA_PAC <- gapminder %>%
  mutate(
    country = as.character(country),
    continent = as.character(continent)
  ) %>%
  rename(
    Pais = country,
    Continente = continent,
    Anio = year,
    Esperanza_de_vida = lifeExp,
    Poblacion = pop,
    PBI_per_capita = gdpPercap
  ) %>%
  mutate(
    Continente = case_when(
      Continente == "Africa" ~ "África",
      Continente == "Americas" ~ "América",
      Continente == "Asia" ~ "Asia",
      Continente == "Europe" ~ "Europa",
      Continente == "Oceania" ~ "Oceanía",
      TRUE ~ Continente
    ),
    PBI_total = PBI_per_capita * Poblacion,
    PBI_log = log(PBI_per_capita)
  ) %>%
  mutate(
    indice_vida = (Esperanza_de_vida - min(Esperanza_de_vida)) /
      (max(Esperanza_de_vida) - min(Esperanza_de_vida)),
    indice_pbi = (PBI_log - min(PBI_log)) /
      (max(PBI_log) - min(PBI_log)),
    Indice_desarrollo = round((indice_vida + indice_pbi) / 2, 3)
  )

# Datos para mapa mundial
world_map <- map_data("world") %>%
  mutate(region = str_replace_all(region, c(
    "USA" = "United States",
    "UK" = "United Kingdom",
    "Democratic Republic of the Congo" = "Congo, Dem. Rep.",
    "Republic of Congo" = "Congo, Rep."
  )))

# 3. INTERFAZ DE USUARIO -----------------------------------

ui <- dashboardPage(
  
  dashboardHeader(
    title = "Panel Mundial Gapminder"
  ),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Resumen", tabName = "resumen", icon = icon("chart-pie")),
      menuItem("Relaciones principales", tabName = "relaciones", icon = icon("chart-line")),
      menuItem("Ranking de países", tabName = "ranking", icon = icon("trophy")),
      menuItem("Evolución temporal", tabName = "evolucion", icon = icon("chart-area")),
      menuItem("Comparación", tabName = "comparacion", icon = icon("globe")),
      menuItem("Mapa mundial", tabName = "mapa", icon = icon("map")),
      menuItem("Tabla de datos", tabName = "tabla", icon = icon("table"))
    ),
    
    selectInput(
      "continente",
      "Selecciona continente:",
      choices = c("Todos", sort(unique(DATA_PAC$Continente))),
      selected = "Todos"
    ),
    
    uiOutput("selector_pais"),
    
    sliderInput(
      "anio",
      "Selecciona año:",
      min = min(DATA_PAC$Anio),
      max = max(DATA_PAC$Anio),
      value = max(DATA_PAC$Anio),
      step = 5,
      sep = ""
    ),
    
    selectInput(
      "variable",
      "Selecciona variable:",
      choices = c(
        "PBI per cápita" = "PBI_per_capita",
        "Esperanza de vida" = "Esperanza_de_vida",
        "Población" = "Poblacion",
        "Índice de desarrollo" = "Indice_desarrollo"
      ),
      selected = "PBI_per_capita"
    ),
    
    numericInput(
      "top_n",
      "Número de países en ranking:",
      value = 10,
      min = 1,
      max = 20
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f4f6f9;
        }
        .box {
          border-radius: 10px;
        }
        .small-box {
          border-radius: 12px;
        }
        .main-header .logo {
          font-weight: bold;
        }
      "))
    ),
    
    # TÍTULO PRINCIPAL DEL DASHBOARD
    fluidRow(
      box(
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        title = "Panel Interactivo de Desarrollo Mundial con Datos Gapminder",
        h4("Análisis comparativo del PBI per cápita, esperanza de vida y población por países y continentes")
      )
    ),
    
    tabItems(
      
      # PESTAÑA 1: RESUMEN
      tabItem(
        tabName = "resumen",
        
        fluidRow(
          valueBoxOutput("box_paises", width = 3),
          valueBoxOutput("box_vida", width = 3),
          valueBoxOutput("box_pbi", width = 3),
          valueBoxOutput("box_poblacion", width = 3)
        ),
        
        fluidRow(
          box(
            title = "Objetivo del dashboard",
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            p("El presente dashboard tiene como objetivo analizar de manera interactiva la evolución del PBI per cápita, la esperanza de vida y la población a nivel global."),
            p("Asimismo, permite comparar países y continentes, identificar desigualdades económicas y sociales, y observar relaciones entre indicadores de desarrollo.")
          )
        ),
        
        fluidRow(
          box(
            title = "Relación entre PBI per cápita y esperanza de vida",
            width = 12,
            plotlyOutput("plot_resumen_burbuja")
          )
        )
      ),
      
      # PESTAÑA 2: RELACIONES PRINCIPALES
      tabItem(
        tabName = "relaciones",
        
        fluidRow(
          box(
            title = "PBI per cápita vs esperanza de vida",
            width = 6,
            plotlyOutput("plot_relacion")
          ),
          
          box(
            title = "Población vs esperanza de vida",
            width = 6,
            plotlyOutput("plot_poblacion")
          )
        ),
        
        fluidRow(
          box(
            title = "Tabla resumen",
            width = 12,
            DTOutput("tabla_resumen")
          )
        )
      ),
      
      # PESTAÑA 3: RANKING
      tabItem(
        tabName = "ranking",
        
        fluidRow(
          box(
            title = "Ranking por PBI per cápita",
            width = 6,
            plotlyOutput("plot_ranking_pbi")
          ),
          
          box(
            title = "Ranking por esperanza de vida",
            width = 6,
            plotlyOutput("plot_ranking_vida")
          )
        ),
        
        fluidRow(
          box(
            title = "Ranking según variable seleccionada",
            width = 12,
            DTOutput("tabla_ranking_variable")
          )
        )
      ),
      
      # PESTAÑA 4: EVOLUCIÓN
      tabItem(
        tabName = "evolucion",
        
        fluidRow(
          box(
            title = "Evolución del PBI per cápita",
            width = 12,
            plotlyOutput("plot_evolucion_pbi")
          )
        ),
        
        fluidRow(
          box(
            title = "Evolución de la esperanza de vida",
            width = 12,
            plotlyOutput("plot_evolucion_vida")
          )
        )
      ),
      
      # PESTAÑA 5: COMPARACIÓN
      tabItem(
        tabName = "comparacion",
        
        fluidRow(
          box(
            title = "Comparación entre continentes",
            width = 12,
            plotlyOutput("plot_comparacion")
          )
        ),
        
        fluidRow(
          box(
            title = "Animación del desarrollo económico y social",
            width = 12,
            plotlyOutput("plot_animacion")
          )
        )
      ),
      
      # PESTAÑA 6: MAPA MUNDIAL
      tabItem(
        tabName = "mapa",
        
        fluidRow(
          box(
            title = "Mapa mundial de esperanza de vida",
            width = 12,
            plotOutput("mapa_mundial"),
            footer = "Fuente: Gapminder"
          )
        )
      ),
      
      # PESTAÑA 7: TABLA
      tabItem(
        tabName = "tabla",
        
        fluidRow(
          box(
            title = "Base de datos filtrada",
            width = 12,
            DTOutput("tabla_datos")
          )
        )
      )
    )
  )
)

# 4. SERVIDOR ----------------------------------------------

server <- function(input, output, session) {
  
  # Selector dinámico de países
  output$selector_pais <- renderUI({
    
    paises_disponibles <- DATA_PAC
    
    if(input$continente != "Todos"){
      paises_disponibles <- paises_disponibles %>%
        filter(Continente == input$continente)
    }
    
    selectInput(
      "pais",
      "Selecciona país:",
      choices = c("Todos", sort(unique(paises_disponibles$Pais))),
      selected = "Todos"
    )
  })
  
  # Datos filtrados por año
  datos_filtrados <- reactive({
    
    datos <- DATA_PAC %>%
      filter(Anio == input$anio)
    
    if(input$continente != "Todos"){
      datos <- datos %>%
        filter(Continente == input$continente)
    }
    
    if(!is.null(input$pais) && input$pais != "Todos"){
      datos <- datos %>%
        filter(Pais == input$pais)
    }
    
    return(datos)
  })
  
  # Datos para evolución temporal
  datos_evolucion <- reactive({
    
    datos <- DATA_PAC
    
    if(input$continente != "Todos"){
      datos <- datos %>%
        filter(Continente == input$continente)
    }
    
    if(!is.null(input$pais) && input$pais != "Todos"){
      datos <- datos %>%
        filter(Pais == input$pais)
    }
    
    return(datos)
  })
  
  # Datos para mapa mundial
  datos_mapa <- reactive({
    
    gapminder_anio <- DATA_PAC %>%
      filter(Anio == input$anio) %>%
      mutate(
        Pais = case_when(
          Pais == "Congo, Dem. Rep." ~ "Democratic Republic of the Congo",
          Pais == "Congo, Rep." ~ "Republic of Congo",
          TRUE ~ Pais
        )
      )
    
    if(input$continente != "Todos"){
      gapminder_anio <- gapminder_anio %>%
        filter(Continente == input$continente)
    }
    
    world_map %>%
      left_join(gapminder_anio, by = c("region" = "Pais"))
  })
  
  # VALUE BOXES
  output$box_paises <- renderValueBox({
    valueBox(
      value = n_distinct(datos_filtrados()$Pais),
      subtitle = "Países analizados",
      icon = icon("flag"),
      color = "blue"
    )
  })
  
  output$box_vida <- renderValueBox({
    valueBox(
      value = paste0(round(mean(datos_filtrados()$Esperanza_de_vida, na.rm = TRUE), 1), " años"),
      subtitle = "Esperanza de vida promedio",
      icon = icon("heartbeat"),
      color = "green"
    )
  })
  
  output$box_pbi <- renderValueBox({
    valueBox(
      value = dollar(round(mean(datos_filtrados()$PBI_per_capita, na.rm = TRUE), 0)),
      subtitle = "PBI per cápita promedio",
      icon = icon("dollar-sign"),
      color = "yellow"
    )
  })
  
  output$box_poblacion <- renderValueBox({
    valueBox(
      value = comma(round(sum(datos_filtrados()$Poblacion, na.rm = TRUE), 0)),
      subtitle = "Población total",
      icon = icon("users"),
      color = "purple"
    )
  })
  
  # GRÁFICO RESUMEN
  output$plot_resumen_burbuja <- renderPlotly({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    ggplotly(
      ggplot(
        datos_filtrados(),
        aes(
          x = PBI_per_capita,
          y = Esperanza_de_vida,
          color = Continente,
          size = Poblacion,
          text = Pais
        )
      ) +
        geom_point(alpha = 0.7) +
        scale_x_log10(labels = dollar) +
        labs(
          title = paste("Relación entre PBI per cápita y esperanza de vida -", input$anio),
          x = "PBI per cápita",
          y = "Esperanza de vida"
        ) +
        theme_minimal(),
      tooltip = c("text", "x", "y")
    )
  })
  
  # RELACIÓN PBI VS VIDA
  output$plot_relacion <- renderPlotly({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    ggplotly(
      ggplot(
        datos_filtrados(),
        aes(
          x = PBI_per_capita,
          y = Esperanza_de_vida,
          color = Continente,
          size = Poblacion,
          text = Pais
        )
      ) +
        geom_point(alpha = 0.7) +
        scale_x_log10(labels = dollar) +
        labs(
          title = "Relación entre PBI y esperanza de vida",
          x = "PBI per cápita",
          y = "Esperanza de vida"
        ) +
        theme_minimal(),
      tooltip = c("text", "x", "y")
    )
  })
  
  # RELACIÓN POBLACIÓN VS VIDA
  output$plot_poblacion <- renderPlotly({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    ggplotly(
      ggplot(
        datos_filtrados(),
        aes(
          x = Poblacion,
          y = Esperanza_de_vida,
          color = Continente,
          text = Pais
        )
      ) +
        geom_point(alpha = 0.7) +
        scale_x_log10(labels = comma) +
        labs(
          title = "Relación entre población y esperanza de vida",
          x = "Población",
          y = "Esperanza de vida"
        ) +
        theme_minimal(),
      tooltip = c("text", "x", "y")
    )
  })
  
  # TABLA RESUMEN
  output$tabla_resumen <- renderDT({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    datos_filtrados() %>%
      select(Pais, Continente, Anio, PBI_per_capita, Esperanza_de_vida, Poblacion) %>%
      arrange(desc(PBI_per_capita)) %>%
      datatable(
        options = list(pageLength = 5, scrollX = TRUE),
        rownames = FALSE
      )
  })
  
  # RANKING PBI
  output$plot_ranking_pbi <- renderPlotly({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    top_paises <- datos_filtrados() %>%
      arrange(desc(PBI_per_capita)) %>%
      head(input$top_n)
    
    ggplotly(
      ggplot(
        top_paises,
        aes(
          x = reorder(Pais, PBI_per_capita),
          y = PBI_per_capita,
          fill = Continente,
          text = paste("PBI:", round(PBI_per_capita, 2))
        )
      ) +
        geom_col() +
        coord_flip() +
        labs(
          title = paste("Top", input$top_n, "países por PBI per cápita"),
          x = "",
          y = "PBI per cápita"
        ) +
        theme_minimal(),
      tooltip = c("text", "y")
    )
  })
  
  # RANKING VIDA
  output$plot_ranking_vida <- renderPlotly({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    top_paises <- datos_filtrados() %>%
      arrange(desc(Esperanza_de_vida)) %>%
      head(input$top_n)
    
    ggplotly(
      ggplot(
        top_paises,
        aes(
          x = reorder(Pais, Esperanza_de_vida),
          y = Esperanza_de_vida,
          fill = Continente,
          text = paste("Años:", round(Esperanza_de_vida, 1))
        )
      ) +
        geom_col() +
        coord_flip() +
        labs(
          title = paste("Top", input$top_n, "países por esperanza de vida"),
          x = "",
          y = "Esperanza de vida"
        ) +
        theme_minimal(),
      tooltip = c("text", "y")
    )
  })
  
  # TABLA RANKING VARIABLE
  output$tabla_ranking_variable <- renderDT({
    
    validate(
      need(nrow(datos_filtrados()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    datos_filtrados() %>%
      arrange(desc(.data[[input$variable]])) %>%
      mutate(Ranking = row_number()) %>%
      select(Ranking, Pais, Continente, Anio, Valor = all_of(input$variable)) %>%
      head(input$top_n) %>%
      datatable(
        options = list(pageLength = input$top_n, scrollX = TRUE),
        rownames = FALSE
      )
  })
  
  # EVOLUCIÓN PBI
  output$plot_evolucion_pbi <- renderPlotly({
    
    validate(
      need(nrow(datos_evolucion()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    ggplotly(
      ggplot(
        datos_evolucion(),
        aes(
          x = Anio,
          y = PBI_per_capita,
          color = Pais,
          group = Pais
        )
      ) +
        geom_line() +
        geom_point() +
        labs(
          title = "Evolución del PBI per cápita",
          x = "Año",
          y = "PBI per cápita"
        ) +
        theme_minimal()
    )
  })
  
  # EVOLUCIÓN VIDA
  output$plot_evolucion_vida <- renderPlotly({
    
    validate(
      need(nrow(datos_evolucion()) > 0, "No hay datos disponibles con los filtros seleccionados")
    )
    
    ggplotly(
      ggplot(
        datos_evolucion(),
        aes(
          x = Anio,
          y = Esperanza_de_vida,
          color = Pais,
          group = Pais
        )
      ) +
        geom_line() +
        geom_point() +
        labs(
          title = "Evolución de la esperanza de vida",
          x = "Año",
          y = "Esperanza de vida"
        ) +
        theme_minimal()
    )
  })
  
  # COMPARACIÓN ENTRE CONTINENTES
  output$plot_comparacion <- renderPlotly({
    
    datos_agrupados <- DATA_PAC %>%
      group_by(Continente, Anio) %>%
      summarise(
        PBI_promedio = mean(PBI_per_capita, na.rm = TRUE),
        Esperanza_promedio = mean(Esperanza_de_vida, na.rm = TRUE),
        Poblacion_total = sum(Poblacion, na.rm = TRUE),
        .groups = "drop"
      )
    
    ggplotly(
      ggplot(
        datos_agrupados,
        aes(
          x = PBI_promedio,
          y = Esperanza_promedio,
          color = Continente,
          frame = Anio,
          size = Poblacion_total
        )
      ) +
        geom_point(alpha = 0.7) +
        scale_x_log10(labels = dollar) +
        labs(
          title = "Comparación entre continentes",
          x = "PBI per cápita promedio",
          y = "Esperanza de vida promedio"
        ) +
        theme_minimal()
    )
  })
  
  # ANIMACIÓN
  output$plot_animacion <- renderPlotly({
    
    validate(
      need(nrow(datos_evolucion()) > 0, "No hay datos disponibles con los filtros seleccionados"),
      need(length(unique(datos_evolucion()$Anio)) > 1, "Se necesitan varios años para la animación")
    )
    
    p <- ggplot(
      datos_evolucion(),
      aes(
        x = PBI_per_capita,
        y = Esperanza_de_vida,
        size = Poblacion,
        color = Continente,
        frame = Anio,
        ids = Pais,
        text = Pais
      )
    ) +
      geom_point(alpha = 0.7) +
      scale_x_log10(labels = dollar) +
      scale_size(range = c(3, 15)) +
      labs(
        title = "Desarrollo económico y social a través del tiempo",
        x = "PBI per cápita",
        y = "Esperanza de vida"
      ) +
      theme_minimal()
    
    ggplotly(p, tooltip = c("text", "x", "y")) %>%
      animation_opts(frame = 1000, transition = 500, redraw = FALSE) %>%
      animation_slider(currentvalue = list(prefix = "Año: "))
  })
  
  # MAPA MUNDIAL
  output$mapa_mundial <- renderPlot({
    
    datos <- datos_mapa()
    
    ggplot(datos, aes(x = long, y = lat, group = group, fill = Esperanza_de_vida)) +
      geom_polygon(color = "white", size = 0.1) +
      scale_fill_viridis(
        option = "C",
        na.value = "grey80",
        name = "Esperanza de vida",
        limits = c(30, 85)
      ) +
      labs(
        title = paste("Esperanza de vida por país -", input$anio),
        caption = "Fuente: Gapminder"
      ) +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        legend.position = "bottom",
        legend.key.width = unit(2, "cm")
      )
  })
  
  # TABLA GENERAL
  output$tabla_datos <- renderDT({
    
    datos_filtrados() %>%
      select(
        Pais,
        Continente,
        Anio,
        Esperanza_de_vida,
        Poblacion,
        PBI_per_capita,
        Indice_desarrollo
      ) %>%
      datatable(
        options = list(pageLength = 10, scrollX = TRUE),
        filter = "top",
        rownames = FALSE
      )
  })
}

# 5. EJECUTAR APLICACIÓN -----------------------------------

shinyApp(ui, server)
