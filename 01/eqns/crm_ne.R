library(tidyverse)
library(knitr)
library(readxl)

# Set working directory
setwd("")

# Gross volume
coefs_VOLCFGRS <- read_excel("eqns/nrs_gtr88/volcfgrs_eqn_coefs.xlsx", 
                   sheet = "NE_coefs") |> 
  rename(COEF_TBL_SP = Species)

config_VOLCFGRS <- read_excel("eqns/nrs_gtr88/volcfgrs_eqn_coefs.xlsx", 
                   sheet = "NE_config") 

coefs_VOLCFGRS <- inner_join(coefs_VOLCFGRS, config_VOLCFGRS, by = "COEF_TBL_SP") |>
  rename(SPCD = SPECIES_NUM) |>
  relocate(SPCD) |> 
  select(-c(COEF_TBL_SP, CONFIG_ID:COEF_TABLE)) 

tree <- inner_join(tree, coefs_VOLCFGRS, by = "SPCD") 

tree <- tree |> 
  rowwise() |> 
          # 1. Gross volume
  mutate(VOLCFGRS = ifelse(DIA >= 5.0, calc_VOLCFGRS(SPCD = SPCD, DBH = DIA, BOLE_HT = BOLEHT, 
                                         B0 = B0, B1 = B1, B2 = B2, B3 = B3, B4 = B4, B5 = B5), 0),
         # 2. Sound volume
         VOLCFSND = calc_VOLCFSND(VOLCFGRS = VOLCFGRS, PCT_ROTTEN = CULL)) |> 
    select(-c(B1:B5, B0))
tree$VOLCFGRS
tree$VOLCFSND

tree <- tree |> 
  rowwise() |> 
  # 3. DRYBIO_BOLE
  mutate(DRYBIO_BOLE = calc_DRYBIO_BOLE(SPCD = SPCD, VOLCFSND = VOLCFSND, 
                                        WOOD_SPGR_GREENVOL_DRYWT = WOOD_SPGR_GREENVOL_DRYWT, 
                                        BARK_VOL_PCT = BARK_VOL_PCT,
                                        BARK_SPGR_GREENVOL_DRYWT = BARK_SPGR_GREENVOL_DRYWT),
      # 4. CRM adjustment factor   
      CRM_AF = calc_CRM_ADJ(JENKINS_SPGRPCD = JENKINS_SPGRPCD, 
                               DRYBIO_BOLE = DRYBIO_BOLE, 
                               DBH = DIA),
      # 5. Stump volume and biomass
      DRYBIO_STUMP = calc_DRYBIO_STUMP(SPCD = SPCD, 
                               DBH = DIA,
                               CRM_AF = CRM_AF,
                               RAILE_STUMP_DOB_B1 = RAILE_STUMP_DOB_B1, 
                               RAILE_STUMP_DIB_B1 = RAILE_STUMP_DIB_B1, 
                               RAILE_STUMP_DIB_B2 = RAILE_STUMP_DIB_B2,
                               WOOD_SPGR_GREENVOL_DRYWT = WOOD_SPGR_GREENVOL_DRYWT, 
                               BARK_SPGR_GREENVOL_DRYWT = BARK_SPGR_GREENVOL_DRYWT),
      # 6. Top and branch biomass
      DRYBIO_TOP = calc_TOP_BRANCH(JENKINS_SPGRPCD = JENKINS_SPGRPCD, 
                                        DBH = DIA, 
                                        DRYBIO_STUMP = DRYBIO_STUMP, 
                                        DRYBIO_BOLE = DRYBIO_BOLE),
      # 7. Total aboveground biomass
      BIOMASS_AG_CRM = calc_BIOMASS(DBH = DIA,
                             JENKINS_SPGRPCD =JENKINS_SPGRPCD,
                             DRYBIO_BOLE = DRYBIO_BOLE, 
                                DRYBIO_STUMP = DRYBIO_STUMP, 
                                DRYBIO_TOP = DRYBIO_TOP),

      # 8. Root biomass
      BIOMASS_BG_CRM = calc_ROOT_BIOMASS(DBH = DIA,
                             JENKINS_SPGRPCD =JENKINS_SPGRPCD)
      ) 
