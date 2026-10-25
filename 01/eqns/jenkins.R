# Calculates the total  biomass of each tree (AGB)
# The equation predicts biomass in kg and uses DBH measured in inches

jenkins <- function(JENKINS_TOTAL_B1, JENKINS_TOTAL_B2, DBH){
  agb_jenkins = (exp(JENKINS_TOTAL_B1 + JENKINS_TOTAL_B2*log(DBH*2.54)))
  return(agb_jenkins)}

# Calculates the root ratio of aboveground biomass 
# The equation predicts biomass in kg and uses DBH measured in inches

jenkins_root <- function(JENKINS_ROOT_RATIO_B1, JENKINS_ROOT_RATIO_B2, 
                         DBH, agb_jenkins){
  root_ratio = (exp(JENKINS_ROOT_RATIO_B1 + JENKINS_ROOT_RATIO_B2/(DBH*2.54)))
  bgb_jenkins = agb_jenkins * root_ratio
  return(bgb_jenkins)}

