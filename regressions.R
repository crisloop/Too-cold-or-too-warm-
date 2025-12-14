## CHAPTER_3 
## We would like to see if there is a direct correlation between some of the intermediate steps
## Clear ALL windows

rm(list = ls(all=TRUE))

# Load packages -----------------------------------------------------------
install.packages("ggplot2")
install.packages("dplyr")
install.packages("openxlsx")
install.packages("ggpmisc")

library(emmeans)
library(ggplot2)
library(dplyr)
library(openxlsx)
library(ggpmisc)

### Reading data ### -----------------------------------------------------------
df3 = read.csv(file="R_correlations.csv", header = TRUE)

### Plotting figures in order of appearance paper ###-----------------------

# Number of germinated pollen vs number of seeds (Figure 5.A)

model = lm(formula = MEAN_number_seeds ~ MEAN_germination_flower, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_germination_flower, y = MEAN_number_seeds,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 2.2351, slope = 0.0016,size=1)+
  xlab((expression(paste("Number of germinated pollen (per flower)")))) +
  ylab((expression(paste("Number of seeds (per fruit)"))))  +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"),
        axis.text.x    = element_text(size = 12),  # X tick labels
        axis.text.y    = element_text(size = 12),  # Y tick labels
        legend.text    = element_text(size = 12),  # Legend labels
        legend.title   = element_text(size = 12), # Legend title
        legend.spacing.y = unit(0.5, "cm")
  )

#  Seed number vs fruit mass (Figure 5.B)

model = lm(formula = MEAN_weight_individual ~ MEAN_number_seeds, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_number_seeds, y = MEAN_weight_individual,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 2.06, slope = 0.078, size=1)+
  xlab((expression(paste("Number of seeds (per fruit)")))) +
  ylab((expression(paste("Fruit mass (gDM per fruit)"))))  +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"),
        axis.text.x    = element_text(size = 12),  # X tick labels
        axis.text.y    = element_text(size = 12),  # Y tick labels
        legend.text    = element_text(size = 12),  # Legend labels
        legend.title   = element_text(size = 12), # Legend title
        legend.spacing.y = unit(0.5, "cm")
  )
        

### [SUPLEMENTARY MATERIAL ]Plotting figures in order of appearance Chapter 4 ###-----------------------

# Fruit set fraction vs number of pollen per flower (Figure A6)

model = lm(formula = MEAN_number_seeds ~ MEAN_pollen_number_flower, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_pollen_number_flower, y = MEAN_number_seeds,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = -0.95, slope = 0.000329,size=1)+
  xlab(expression(paste("Number of pollen (per flower)"))) +
  ylab((expression(paste("Number of seeds (per fruit)"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


# Fruit set fraction vs number of pollen per flower (Figure A7)

model = lm(formula = MEAN_fraction_fruit_set ~ MEAN_pollen_number_flower, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_pollen_number_flower, y = MEAN_fraction_fruit_set,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 0.631, slope = 0.00000265,size=1)+
  xlab(expression(paste("Number of pollen (per flower)"))) +
  ylab((expression(paste("Fraction fruit set (-)"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


# Fruit mass vs total number of pollen (Figure A8)

model = lm(formula = MEAN_weight_individual ~ MEAN_pollen_number_flower, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_pollen_number_flower, y = MEAN_weight_individual,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 1.382, slope = 0.0000419,size=1)+
  xlab(expression(paste("Number of pollen (per flower)"))) +
  ylab((expression(paste("Fruit mass (gDM"," ","fruit"^-1,")"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


# Fruit set fraction and germination fraction (Figure A9)

model = lm(formula = MEAN_fraction_fruit_set ~ MEAN_germinated_fraction, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_germinated_fraction, y = MEAN_fraction_fruit_set,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 0.6923, slope = 0.3386,size=1)+
  xlab(expression(paste("Germination fraction (-)"))) +
  ylab((expression(paste("Fraction fruit set (-)"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


# Fruit set fraction and number of germinated pollen (Figure A10)

model = lm(formula = MEAN_fraction_fruit_set ~ MEAN_germination_flower, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_germination_flower, y = MEAN_fraction_fruit_set,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 0.7024, slope = 0.00000754,size=1)+
  xlab(expression(paste("Number of germinated pollen (per fruit)"))) +
  ylab((expression(paste("Fraction fruit set (-)"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))



# Fruit set fraction vs number of seeds (Figure A11)

model = lm(formula = MEAN_fraction_fruit_set ~ MEAN_number_seeds, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_number_seeds, y = MEAN_fraction_fruit_set,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = 0.7063, slope = 0.0032,size=1)+
  xlab(expression(paste("Number of seeds (per fruit)"))) +
  ylab((expression(paste("Fraction fruit set (-)"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


# Fruit mass vs fraction of fruit set (Figure A12)

model = lm(formula = MEAN_weight_individual ~ MEAN_fraction_fruit_set, data = df3)
summary (model)

ggplot () + 
  geom_point(data=df3, mapping = aes(x = MEAN_fraction_fruit_set, y = MEAN_weight_individual,
                                     colour=Temperature, shape=Duration), size = 4)+
  geom_abline(intercept = -1.75, slope = 6.346,size=1)+
  xlab(expression(paste("Fraction fruit set (-)"))) +
  ylab((expression(paste("Fruit mass (gDM"," ","fruit"^-1,")"))))  +
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 18, face = "bold"),
        axis.title.y = element_text(size = 18, face = "bold"))


