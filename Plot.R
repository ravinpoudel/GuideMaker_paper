# load library
library(tidyverse)
library(ggsci)
library(ggplot2)
library(gridExtra)
library(cowplot)
library(scales)

source("summarySE.R")


## load data
data_avx2 <- read.csv("avx2_out.csv", header = TRUE, stringsAsFactors = FALSE)
data_avx2["Processor"] <- "AVX2"
data_avx2["log_time"] <- log(data_avx2$process_sec)


data_nonavx2 <- read.csv("nonavx2_out.csv", header = TRUE, stringsAsFactors = FALSE)
data_nonavx2["Processor"] <- "nonAVX2"
data_nonavx2["log_time"] <- log(data_nonavx2$process_sec)


# combine data
dataall <- bind_rows(data_avx2,data_nonavx2 )
# remove data with 32 cores and nonavx
data <- dataall %>% filter(threads!=32) %>% filter(Processor=="AVX2")
# data$Genome <- gsub('Pseudomonas_aeruginosa_PAO1_107.gbk', 'Pseudomonas aeruginosa', data$Genome)
# data$Genome <- gsub('Burkholderia_thailandensis_E264_ATCC_700388_133.gbk', 'Burkholderia thailandensis', data$Genome)
# data$Genome <- gsub('Escherichia.coli_str_K-12_substr_MG1655.gbk', 'Escherichia coli', data$Genome)
# data$Genome <- gsub('Aspergillus_fumigatus.gbk', 'Aspergillus fumigatus', data$Genome)
# data$Genome <- gsub('Arabidopsis_thaliana.gbk', 'Arabidopsis thaliana', data$Genome)
# data$Genome <- gsub('GCF_000499845.1_PhaVulg1_0_genomic.gbff', 'Phaseolus vulgaris', data$Genome)


##########
main_fig <- c("Escherichia.coli_str_K-12_substr_MG1655.gbk", "Pseudomonas_aeruginosa_PAO1_107.gbk", "Burkholderia_thailandensis_E264_ATCC_700388_133.gbk")

data_main <- data[data$Genome %in% main_fig, ] %>%
  filter(PAM =="NGG")

######### non log graph #############
sel_data <- data_main %>%
  select(Genome, PAM, threads, process_sec)

## Get summary stat
summarystat <- summarySE(sel_data, measurevar="process_sec", groupvars=c("Genome","PAM", "threads"))

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.05) # move them .05 to the left and right


# plot
p3 <- ggplot(summarystat, aes(x=threads, y=process_sec, colour=Genome, group=Genome)) + 
  geom_errorbar(aes(ymin=process_sec-sd, ymax=process_sec+sd), colour="black", width=.5, position=pd, size=1) +
  geom_line(position=pd, size=1) +
  geom_point(position=pd, size=3, shape=21, fill="white") + # 21 is filled circle
  theme_cowplot()+
  xlab("Processor cores") +
  ylab("Run time in seconds") +
  expand_limits(y=0) 
# Expand y range
  # theme(legend.justification=c(1,0),
  #       legend.text = element_text(color = "black", size= 5),
  #       legend.position=c(0.45,0.70))# Position legend (left-right, top-bottom)

p3 + theme(axis.text = element_text(color="black", size = 16),
           axis.title  = element_text(color="black", size = 16, face = "bold"))+
  theme(legend.title = element_text(face = "bold"))+
  scale_y_continuous(breaks = seq(0, 350, 50))+
  theme(legend.key.size = unit(1, 'lines'),
        legend.position = c(0.3, 0.8),
        legend.text = element_text(size=10))+
  coord_cartesian(ylim=c(0, 300))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))

## Fixing axis text size
# p3 + theme(axis.text.x = element_text(color = "black", size = 50),
#                  axis.text.y = element_text(color = "black", size = 20, angle = 0),  
#                  axis.title.x = element_text(color = "black", size = 20, angle = 0, face="bold"),
#                  axis.title.y = element_text(color = "black", size = 20, angle = 90, face="bold")) +
#   theme_classic()+
#   theme(legend.title = element_text(face = "bold"))+
#   scale_y_continuous(breaks = seq(0, 300, 50))+
#   theme(legend.key.size = unit(1, 'lines'),
#         legend.position = c(0.6, 0.8),
#         legend.text = element_text(size=12))
        #legend.background = element_rect(fill = "NA")) 

# p6 <- p3 + scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32)) +
#   scale_y_continuous(breaks = seq(0, 300, 50))

# 
# p6 + theme(legend.key.size = unit(0, 'lines')) 

# Save the plot
ggsave("figures/Figure 4. Performance of GuideMaker for SpCas9.pdf", width = 8, height = 4, units = "in")
ggsave("figures/Figure 4. Performance of GuideMaker for SpCas9.png", width = 8, height = 4, units = "in")

dev.off()

print("Figure 4. Performance of GuideMaker for SpCas9.pdf")


##
file.remove("Rplots.pdf")

################## supplement_fig 1 #############


supp_fig_1 <- data[data$Genome %in% main_fig, ] %>%
  filter(PAM =="NNAGAAW" | PAM =="NNGRRT" )


sel_supp_fig_1 <- supp_fig_1 %>%
  select(Genome, PAM, threads, process_sec)

## Get summary stat
summarystat_sel_supp_fig_1 <- summarySE(sel_supp_fig_1, measurevar="process_sec", groupvars=c("Genome","PAM", "threads"))

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.05) # move them .05 to the left and right


# plot
p3 <- ggplot(summarystat_sel_supp_fig_1, aes(x=threads, y=process_sec, colour=Genome, group=Genome)) + 
  geom_errorbar(aes(ymin=process_sec-sd, ymax=process_sec+sd), colour="black", width=.1, position=pd, size=1) +
  geom_line(position=pd) +
  geom_point(position=pd, size=2, shape=21, fill="white") + # 21 is filled circle
  theme_bw()+
  xlab("Processor cores") +
  ylab("Run time in seconds") +
  expand_limits(y=0) +
  facet_grid(PAM ~ .)

p3 + theme(axis.text = element_text(color="black", size = 16),
           axis.title  = element_text(color="black", size = 16, face = "bold"))+
  theme(legend.title = element_text(face = "bold"))+
  scale_y_continuous(breaks = seq(0, 50, 25))+
  theme(legend.key.size = unit(1, 'lines'),
        legend.position = c(0.5, 0.8),
        strip.text = element_text(size=16),
        legend.background = element_rect(fill = "NA"),
        legend.text = element_text(size=10))+
  coord_cartesian(ylim=c(0, 50))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))


# Save the plot
ggsave("figures/Supplemental Figure 1. Performance of GuideMaker for SaCas9 and StCas9.pdf", width = 8, height = 6, units = "in")
ggsave("figures/Supplemental Figure 1. Performance of GuideMaker for SaCas9 and StCas9.png", width = 8, height = 6, units = "in")

dev.off()

print("Supplemental Figure 1. Performance of GuideMaker for SaCas9 and StCas9.pdf")


##
file.remove("Rplots.pdf")



################## supplement_fig 2 #############

supp_fig <- c("Aspergillus_fumigatus.gbk",
              "Arabidopsis_thaliana.gbk",
              "GCF_000499845.1_PhaVulg1_0_genomic.gbff")


supp_fig_2 <- data[data$Genome %in% supp_fig, ]


sel_supp_fig_2 <- supp_fig_2 %>%
  select(Genome, PAM, threads, process_sec)

## Get summary stat
summarystat_sel_supp_fig_2 <- summarySE(sel_supp_fig_2, measurevar="process_sec", groupvars=c("Genome","PAM", "threads"))

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.05) # move them .05 to the left and right


# plot
p3 <- ggplot(summarystat_sel_supp_fig_2, aes(x=threads, y=process_sec, colour=Genome, group=Genome)) + 
  geom_errorbar(aes(ymin=process_sec-sd, ymax=process_sec+sd), colour="black", width=.1, position=pd, size=1) +
  geom_line(position=pd) +
  geom_point(position=pd, size=2, shape=21, fill="white") + # 21 is filled circle
  theme_bw()+
  xlab("Processor cores") +
  ylab("Run time in seconds") +
  expand_limits(y=0) +
  facet_grid(PAM ~ .)

p3 + theme(axis.text = element_text(color="black", size = 16),
           axis.title  = element_text(color="black", size = 16, face = "bold"))+
  theme(legend.title = element_text(face = "bold"))+
  scale_y_continuous(breaks = seq(0, 4000, 2000))+
  theme(legend.key.size = unit(1, 'lines'),
        legend.position = c(0.4, 0.5),
        strip.text = element_text(size=16),
        legend.background = element_rect(fill = "NA"),
        legend.text = element_text(size=10))+
  coord_cartesian(ylim=c(0, 4000))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))

# Save the plot
ggsave("figures/Supplemental Figure 2. Performance of GuideMaker for SpCas9, SaCas9 and StCas9.pdf", width = 8, height = 6, units = "in")
ggsave("figures/Supplemental Figure 2. Performance of GuideMaker for SpCas9, SaCas9 and StCas9.png", width = 8, height = 6, units = "in")

dev.off()

print("Supplemental Figure 2. Performance of GuideMaker for SpCas9, SaCas9 and StCas9.pdf")


##
file.remove("Rplots.pdf")



########### Memory Usage Plots####################
library(tidyverse)
sel_data <- data %>%
  select(Genome, PAM, threads, MemoryUsage)
sel_data["MemoryUsage"] <- round(sel_data$MemoryUsage/1e6, 1)

# sel_data$Genome <- gsub('Pseudomonas_aeruginosa_PAO1_107.gbk', 'Pseudomonas aeruginosa', sel_data$Genome)
# sel_data$Genome <- gsub('Burkholderia_thailandensis_E264_ATCC_700388_133.gbk', 'Burkholderia thailandensis', sel_data$Genome)
# sel_data$Genome <- gsub('Escherichia.coli_str_K-12_substr_MG1655.gbk', 'Escherichia coli', sel_data$Genome)
# sel_data$Genome <- gsub('Aspergillus_fumigatus.gbk', 'Aspergillus fumigatus', sel_data$Genome)
# sel_data$Genome <- gsub('Arabidopsis_thaliana.gbk', 'Arabidopsis thaliana', sel_data$Genome)
# sel_data$Genome <- gsub('GCF_000499845.1_PhaVulg1_0_genomic.gbff', 'Phaseolus vulgaris', sel_data$Genome)
# 

## Get summary stat
summarystat <- summarySE(sel_data, measurevar="MemoryUsage", groupvars=c("Genome","PAM", "threads"))
write.csv(summarystat,"memory_usage.csv")

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.5) # move them .05 to the left and right


# plot
p3 <- ggplot(summarystat, aes(x=threads, y=MemoryUsage, colour=Genome, group=Genome)) + 
  geom_errorbar(aes(ymin=MemoryUsage-sd, ymax=MemoryUsage+sd), colour="black", width=.1, position=pd, size=1) +
  geom_line(position=pd) +
  geom_point(position=pd, size=2, shape=21, fill="white") + # 21 is filled circle
  xlab("Processor cores") +
  ylab("Memory Usage in GB") +
  expand_limits(y=0) + # Expand y range
  theme_bw() +
facet_grid(PAM ~ .)


p3+ theme(axis.text = element_text(color="black", size = 16),
           axis.title  = element_text(color="black", size = 16, face = "bold"))+
  theme(legend.title = element_text(face = "bold"))+
  scale_y_continuous(breaks = seq(0, 50, 25))+
  theme(legend.key.size = unit(0, 'lines'),
        legend.position = c(0.5, 0.55),
        strip.text = element_text(size=16),
        legend.background = element_rect(fill = "NA"),
        legend.text = element_text(size=10))+
  coord_cartesian(ylim=c(0, 50))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))

# Save the plot
ggsave("figures/Supplemental Figure 4. Memory usage of GuideMaker for SpCas9, SaCas9, and StCas9.pdf", width = 8, height = 6, units = "in")
ggsave("figures/Supplemental Figure 4. Memory usage of GuideMaker for SpCas9, SaCas9, and StCas9.png", width = 8, height = 6, units = "in")

dev.off()

print("Supplemental Figure 4. Performance of GuideMaker with AVX2 settings.pdf")


##
file.remove("Rplots.pdf")


################## supplement_fig 3 #############
######improvement over AVX2 #########

impdata <- dataall %>%
  select(Genome, PAM, threads, process_sec, Processor) %>%
  filter(threads!=32)

## Get summary stat
summarystat <- summarySE(impdata, measurevar="process_sec", groupvars=c("Genome","PAM", "threads","Processor"))
write.csv(summarystat,"ProcessTime.csv")

Gain = impdata %>%
  select(PAM, threads,  Processor, process_sec, Genome) %>%
  group_by(PAM, threads,  Processor, Genome) %>%
  summarise_at(vars(process_sec),list(SumProcessTime = sum, MeanRuntime = mean, SdRuntime=sd)) %>%
  mutate(xx = (SdRuntime/MeanRuntime)^2) %>%
  select(PAM, threads, Genome, Processor, xx) %>%
  spread(Processor,xx) %>%
  mutate(yy = AVX2 + nonAVX2) %>%
  mutate(zz = sqrt(yy))



Gain2 = impdata %>%
  select(PAM, threads,  Processor, process_sec, Genome) %>%
  group_by(PAM, threads,  Processor, Genome) %>%
  summarise_at(vars(process_sec),list(MeanRuntime = mean)) %>%
  spread(Processor,MeanRuntime) %>%
  mutate(MeanRatio = AVX2/nonAVX2) 


Gain3 <- left_join(Gain, Gain2, by =c("PAM", "threads", "Genome")) %>%
  mutate(UQ = MeanRatio * zz)


Gain4 <- impdata %>%
group_by(PAM, threads,  Processor, Genome) %>%
summarise_at(vars(process_sec),list(SumProcessTime = sum)) %>%
arrange(Processor) %>%
spread(Processor,SumProcessTime) %>%
mutate(`Improvement%` = (nonAVX2-AVX2)/nonAVX2 * 100)


Gain5 <- left_join(Gain3, Gain4, by =c("PAM", "threads", "Genome"))
Gain5$threads <- as.factor(Gain5$threads)

Gain5$Genome <- factor(Gain5$Genome, labels=c("A.thaliana", "A.fumigatus", "B.thailandensis","E.coli","PhaVulg1","P.aeruginosa"))


# Default bar plot
p<- ggplot(Gain5, aes(x=threads, y=`Improvement%`, fill=as.factor(threads))) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=`Improvement%` - UQ, ymax= `Improvement%`+UQ), width=.2,
                position=position_dodge(.9)) +  theme_bw() + facet_grid(Genome ~ PAM)


p2 <-  p + scale_fill_lancet() +
  xlab("Processor cores") +
  ylab("Improvement % with AVX2") +
  theme(legend.position = "none")

p3 <- p2 + theme(strip.text.y = element_text(size = 12, colour = "black"), 
                 strip.text.x = element_text(size = 12, colour = "black", face="bold"),
                 axis.title.x = element_text(color = "black", size = 12, angle = 0, face="bold"),
                 axis.title.y = element_text(color = "black", size = 12, face="bold"),
                 axis.text.y = element_text(color = "black", size = 10, angle = 0),
                 axis.text.x = element_text(color = "black", size = 10, angle = 0))
p3

ggsave("figures/Supplemental Figure 3. Performance of GuideMaker with AVX2 settings.pdf", width = 8, height = 8, units = "in")
ggsave("figures/Supplemental Figure 3. Performance of GuideMaker with AVX2 settings.png", width = 8, height = 8, units = "in")


dev.off()

print("Supplemental Figure 3. Performance of GuideMaker with AVX2 settings.pdf")


##
file.remove("Rplots.pdf")


### Chopchop cli vs gm ecloi genome comparisons.

data_ecoli <- read.csv("chochop_gm_ecoli.csv", header = TRUE) %>%
  filter(threads!=32)


gg_chop_gm_ps = data_ecoli %>%
  select(-MemoryUsage) %>%
  ggplot(aes(x=threads, y=process_sec, colour=Method, group=Method)) + 
  geom_line(size =1) +
  geom_point(size=3, shape=21, fill="white") + # 21 is filled circle
  xlab("Processor cores") +
  ylab("Run time in seconds") +
  expand_limits(y=0) + # Expand y range
  theme_classic() +
  theme(legend.justification=c(1,0),
        legend.text = element_text(color = "black", size= 5),
        legend.position="bottom")+
theme(axis.text.x = element_text(color = "black", size = 16, angle = 0),
                 axis.text.y = element_text(color = "black", size = 16, angle = 0),  
                 axis.title.x = element_text(color = "black", size = 16, angle = 0, face="bold"),
                 axis.title.y = element_text(color = "black", size = 16, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size = 8))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))+
  scale_y_continuous(breaks = seq(0, 6000, 1000))+
  theme(legend.key.size = unit(0, 'cm'),
        legend.background = element_rect(fill = "NA"),
        legend.text = element_text(size = 8, face = "bold"))

  


gg_chop_gm_ms = data_ecoli %>%
  select(-process_sec) %>%
  mutate(musage = round(MemoryUsage/1e6, 1)) %>%
  ggplot(aes(x=threads, y=musage, colour=Method, group=Method)) + 
  geom_line(size =1) +
  geom_point(size=3, shape=21, fill="white") + # 21 is filled circle
  xlab("Processor cores") +
  ylab("Memory Usage in GB") +
  expand_limits(y=0) + # Expand y range
  theme_classic() +
  theme(legend.justification=c(1,0),
        legend.text = element_text(color = "black", size= 5),
        legend.position=c(0.9,0.50))+
  theme(axis.text.x = element_text(color = "black", size = 16, angle = 0),
        axis.text.y = element_text(color = "black", size = 16, angle = 0),  
        axis.title.x = element_text(color = "black", size = 16, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 16, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size=8))+
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24, 28, 32))+
  theme(legend.position = 'bottom',
        legend.key.size = unit(0, 'cm'),
        legend.text = element_text(size = 8, face = "bold"))


plot_grid(gg_chop_gm_ps, gg_chop_gm_ms, align = "hv")

ggsave("figures/Supplemental Figure 5. CHOPCHOP_CLI_vs_GM_Ecoli.pdf", width = 8, height = 6, units = "in")
ggsave("figures/Supplemental Figure 5. CHOPCHOP_CLI_vs_GM_Ecoli.png", width = 8, height = 6, units = "in")


library(tidyverse)
df = data_ecoli %>%
  mutate(MemoryUsage = MemoryUsage/1e6) %>%
  select(Method, process_sec, MemoryUsage) %>%
  group_by(Method) 

df%>% filter(Method=="GuideMaker") %>%
  summarise(mean_ps=mean(process_sec),
            sd_ps = sd(process_sec),
            mean_ms = mean(MemoryUsage),
            sd_ms = sd(MemoryUsage))


df%>% filter(Method=="CHOPCHOP") %>%
  summarise(mean_ps=mean(process_sec),
            sd_ps = sd(process_sec),
            mean_ms = mean(MemoryUsage),
            sd_ms = sd(MemoryUsage))


######### with and without filter in E.coli ###############

df_with_filter_doench<- read.csv("targets_with_filter_doench.csv", header = TRUE)

df_without_filter_doench <- read.csv("targets_without_filter_doench.csv", header = TRUE)



########
withfilter_doench <- data.frame(Efficiency=df_with_filter_doench$Efficiency, type="GuideMaker (with filter)")
withoutfilter_doench <- data.frame(Efficiency=df_without_filter_doench$Efficiency, type="GuideMaker (without filter)")

# and combine into your new data frame vegLengths
alldata_doench <- rbind(withfilter_doench, withoutfilter_doench)

ggplot(alldata_doench, aes(x=Efficiency,y=..count.., fill = type)) +
  geom_density(alpha = 0.2) +
  theme_classic() +
  theme(axis.text.x = element_text(color = "black", size = 16, angle = 0),
        axis.text.y = element_text(color = "black", size = 16, angle = 0),  
        axis.title.x = element_text(color = "black", size = 16, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 16, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size=8))+
  theme(legend.position = 'right',
        legend.key.size = unit(0.5, 'cm'),
        legend.title = element_blank(),
        legend.text = element_text(size = 8, face = "bold"))+
  ylab("Count")+
  xlab("Doench Efficiency Score")+
  coord_cartesian(xlim = c(0, 1))+
  scale_y_continuous(labels = label_number(suffix = " M", scale=1e-6))


### histogram
hist(withfilter_doench$Efficiency)
hist(withoutfilter_doench$Efficiency)

gg_doench <- ggplot(alldata_doench, aes(x = Efficiency, fill = type)) +                    
  geom_histogram(position = "identity", alpha = 0.4, bins = 50) +
  theme_classic() +
  theme(axis.text.x = element_text(color = "black", size = 14, angle = 0),
        axis.text.y = element_text(color = "black", size = 14, angle = 0),  
        axis.title.x = element_text(color = "black", size = 14, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 14, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size=8))+
  theme(legend.position = 'none',
        legend.key.size = unit(0.5, 'cm'),
        legend.title = element_blank(),
        legend.text = element_text(size = 12, face = "bold"))+
  xlab("Doench Efficiency Score")+
  coord_cartesian(ylim = c(0, 45000), xlim = c(0, 1))+
  scale_y_continuous(expand = c(0,0), labels = label_number(suffix = " K", scale=1e-3))+
  ylab("Count")



############################################


cfd_without_filter <- read.csv("targets_without_filter_cfd.csv", header = TRUE)
cfd_with_filter <- read.csv("targets_with_filter_cfd.csv", header = TRUE)


withoutfilter_cdf <- data.frame(CDF=cfd_without_filter$max_cfd, type="GuideMaker (without filter)")
withfilter_cdf <- data.frame(CDF=cfd_with_filter$Max.CFD, type="GuideMaker (with filter)")
# and combine into your new data frame vegLengths
alldata_cdf <- rbind(withfilter_cdf, withoutfilter_cdf)


ggplot(alldata_cdf, aes(x=CDF,y=..count.., fill = type)) +
  geom_density(alpha = 0.2) +
  theme_classic() +
  theme(legend.justification=c(1,0),
        legend.text = element_text(color = "black", size= 5),
        legend.position=c(0.9,0.50))+
  theme(axis.text.x = element_text(color = "black", size = 16, angle = 0),
        axis.text.y = element_text(color = "black", size = 16, angle = 0),  
        axis.title.x = element_text(color = "black", size = 16, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 16, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size=8))+
  theme(legend.position = 'bottom',
        legend.key.size = unit(0.5, 'cm'),
        legend.title = element_blank(),
        legend.text = element_text(size = 8, face = "bold"))+
  ylab("Count")+
  coord_cartesian(xlim = c(0, 0.02))+
  scale_y_continuous(labels = label_number(suffix = " M", scale=1e-6))


### histogram
hist(cfd_with_filter$Max.CFD)
hist(cfd_without_filter$max_cfd)

gg_cdf <- ggplot(alldata_cdf, aes(x = CDF, fill = type)) +                    
  geom_histogram(position = "identity", alpha = 0.4, bins = 50) +
  theme_classic() +
  theme(axis.text.x = element_text(color = "black", size = 14, angle = 0),
        axis.text.y = element_text(color = "black", size = 14, angle = 0),  
        axis.title.x = element_text(color = "black", size = 14, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 14, angle = 90, face="bold")) +
  theme(legend.title = element_blank())+
  xlab("CFD Score")+
  ylab("Count")+
  scale_y_continuous(expand = c(0,0), labels = label_number(suffix = " M", scale=1e-6))+
  theme(legend.justification=c(1,0),
        legend.text = element_text(color = "black", size= 10, face = "bold"),
        legend.position=c(0.9,0.50))+
  coord_cartesian(ylim = c(0, 550000))

plot_grid(gg_doench, gg_cdf, align = 'hv')

ggsave("figures/Supplemental Figure 6. Doench_CDF.pdf", width = 8, height = 4, units = "in")
ggsave("figures/Supplemental Figure 6. Doench_CDF.png", width = 8, height = 4, units = "in")

############# NGG 
targets_ecoli_ngg_hamming <- read.csv("targets_ecoli_ngg_hamming.csv", header = TRUE, stringsAsFactors = FALSE)
targets_ecoli_ngg_leven <- read.csv("targets_ecoli_ngg_leven.csv", header = TRUE, stringsAsFactors = FALSE)


guideseq_ecoli_ngg_hamming <- unique(targets_ecoli_ngg_hamming$Guide.sequence)
hm <- length(guideseq_ecoli_ngg_hamming)
guideseq_ecoli_ngg_leven <- unique(targets_ecoli_ngg_leven$Guide.sequence)
lev <- length(guideseq_ecoli_ngg_leven)

common <- intersect(guideseq_ecoli_ngg_hamming,guideseq_ecoli_ngg_leven)
hm_lv_common <- length(common)
hm_lv_common/lev * 100


########## nngrrt
leven_nngrrt <- read.csv("targets_leven_nngrrt.csv", header = TRUE, stringsAsFactors = FALSE)
hamming_nngrrt <- read.csv("targets_hamming_nngrrt.csv", header = TRUE, stringsAsFactors = FALSE)

nngrrt_leven <- unique(leven_nngrrt$Guide.sequence)
nngrrt_hamming <- unique(hamming_nngrrt$Guide.sequence)

common <- intersect(nngrrt_leven,nngrrt_hamming)

length(common) / length(nngrrt_leven) * 100

########  NNAGAAW  
leven_nnagaaw <-  read.csv("targets_leven_nnagaaw.csv", header = TRUE, stringsAsFactors = FALSE)
hamming_nnagaaw <-  read.csv("targets_hamming_nnagaaw.csv", header = TRUE, stringsAsFactors = FALSE)

leven_nnagaaw_uniq <- unique(leven_nnagaaw$Guide.sequence)
hamming_nnagaaw_uniq <- unique(hamming_nnagaaw$Guide.sequence)

common <- intersect(leven_nnagaaw_uniq,hamming_nnagaaw_uniq)

length(leven_nnagaaw_uniq)
length(hamming_nnagaaw_uniq )

length(common)/length(leven_nnagaaw_uniq) * 100


############# Leven_Hamming_Comparison for Vulgaris Genome ###############
library(tidyverse)

## NGG
leven_ngg <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NGG_Leven/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
hamming_ngg <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NGG_Hamming/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
ngg_overlap <- sum(hamming_ngg %in% leven_ngg)/length(leven_ngg) * 100
ngg_overlap

## NNGRRT
leven_nngrrt <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NNGRRT_Leven/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
hamming_nngrrt <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NNGRRT_Hamming/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
nngrrt_overlap <- sum(hamming_nngrrt %in% leven_nngrrt)/length(leven_nngrrt) * 100
nngrrt_overlap

## NNAGAAW
leven_nnagaaw <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NNAGAAW_Leven/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
hamming_nnagaaw <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_phaeous_leven_hamming/Vulgaris_NNAGAAW_Hamming/targets.csv", header = TRUE) %>% select(Guide.sequence) %>% pull()
nnagaaw_overlap <- sum(hamming_nnagaaw %in% leven_nnagaaw)/length(leven_nnagaaw) * 100
nnagaaw_overlap


######### analyses of human genome ##############
# This analysis is based on .err files (logs) from GuideMaker_ALL/GuideMaker_paper/all_slurm_logs_script_from_atlas/guidemaker/avx_human/
human_df <- read.csv("all_slurm_logs_script_from_atlas/guidemaker/avx_human/human_genome_summary.csv", header = TRUE)
human_df["Run_Type"] <- c("(A) Guidelength: 20; lsr: 11; dtype: hamming", "(A) Guidelength: 20; lsr: 11; dtype: hamming", "(A) Guidelength: 20; lsr: 11; dtype: hamming",
                          "(B) Guidelength: 25; lsr: 20; dtype: hamming", "(B) Guidelength: 25; lsr: 20; dtype: hamming", "(B) Guidelength: 25; lsr: 20; dtype: hamming")

human_df$PAM <- factor(human_df$PAM, levels=c("NGG","NNGRRT","NNAGAAW"))

p <-ggplot(data=human_df, aes(x=PAM, y=Run.time.in.seconds, fill=PAM)) +
  geom_bar(stat="identity")+
  facet_grid(~Run_Type) +
  theme_bw()+
  theme(axis.text.x = element_text(color = "black", size = 10, angle = 0),
        axis.text.y = element_text(color = "black", size = 10, angle = 0),  
        axis.title.x = element_text(color = "black", size = 16, angle = 0, face="bold"),
        axis.title.y = element_text(color = "black", size = 16, angle = 90, face="bold")) +
  theme(legend.title = element_text(face = "bold", size=8))+
  theme(legend.position = 'none',
        legend.key.size = unit(0.5, 'cm'),
        legend.title = element_blank(),
        legend.text = element_text(size = 8, face = "bold"))+
  theme(strip.text.x = element_text(size=12, face = "bold", angle=0))+
  ylab("Run time in seconds")+
  xlab(" ") +
  scale_y_continuous(limits = c(0,80000), expand = c(0,0), labels = label_number(suffix = " K", scale=1e-3))+
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"))

p             
  
# Save the plot
ggsave("figures/Figure 7. Performance of GuideMaker for human genome.pdf", width = 8, height = 4, units = "in")
ggsave("figures/Figure 7. Performance of GuideMaker for human genome.png", width = 8, height = 4, units = "in")                    

