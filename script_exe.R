# Packages ------------------------------------------------------------- ####
library('quarto')
library('dplyr')
library('purrr')
library('qpdf')
library('glue')

# Données eleves ------------------------------------------------------- ####
eleves <- read.csv2('donnees/eleves.csv') 

# Données classes ------------------------------------------------------ ####
classes <- read.csv2('donnees/classes.csv')

# Appel template quarto ------------------------------------------------ ####

rendu_classe <- function(id) {
  maclasse <- classes %>% filter(id_cl == id)
  quarto_render(
    input = "temp_quarto.qmd",
    output_file = glue("{maclasse$classe}.pdf"),
    execute_params = list(
      classe = maclasse$classe,
      jour = maclasse$jour,
      heure = maclasse$heure,
      salle = maclasse$salle,
      prof = maclasse$prof
    )
  )
}

classes %>% 
  distinct(id_cl) %>% 
  pull(id_cl) %>% 
  walk(function(x) rendu_classe(x))

# Fusion des fichiers ----------------------------------------------------####
classes %>% 
  distinct(classe) %>% 
  pull(classe) %>% 
  paste0(".pdf") %>% 
  pdf_combine(output = "_outputs/output.pdf")

# Suppression des fichiers classes -------------------------------------- ####

classes %>% 
  distinct(classe) %>% 
  pull(classe) %>% 
  paste0(".pdf") %>% 
  file.remove()
