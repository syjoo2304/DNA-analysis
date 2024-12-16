# ggplot2 is a handy package for plotting
library(ggplot2)
# generate a pretty format for p-value output

prs.result$print.p <- round(prs.result$P, digits = 3)
prs.result$print.p[!is.na(prs.result$print.p) &
                    prs.result$print.p == 0] <-
    format(prs.result$P[!is.na(prs.result$print.p) &
                            prs.result$print.p == 0], digits = 2)
prs.result$print.p <- sub("e", "*x*10^", prs.result$print.p)
# Initialize ggplot, requiring the threshold as the x-axis (use factor so that it is uniformly distributed)
ggplot(data = prs.result, aes(x = factor(Threshold), y = R2)) +
    # Specify that we want to print p-value on top of the bars
    geom_text(
        aes(label = paste(print.p)),
        vjust = -1.5,
        hjust = 0,
        angle = 45,
        cex = 4,
        parse = T
    )  +
    # Specify the range of the plot, *1.25 to provide enough space for the p-values
    scale_y_continuous(limits = c(0, max(prs.result$R2) * 1.25)) +
    # Specify the axis labels
    xlab(expression(italic(P) - value ~ threshold ~ (italic(P)[T]))) +
    ylab(expression(paste("PRS model fit:  ", R ^ 2))) +
    # Draw a bar plot
    geom_bar(aes(fill = -log10(P)), stat = "identity") +
    # Specify the colors
    scale_fill_gradient2(
        low = "dodgerblue",
        high = "firebrick",
        mid = "dodgerblue",
        midpoint = 1e-4,
        name = bquote(atop(-log[10] ~ model, italic(P) - value),)
    ) +
    # Some beautification of the plot
    theme_classic() + theme(
        axis.title = element_text(face = "bold", size = 18),
        axis.text = element_text(size = 14),
        legend.title = element_text(face = "bold", size =
                                        18),
        legend.text = element_text(size = 14),
        axis.text.x = element_text(angle = 45, hjust =
                                    1)
    )
ggsave("ARHL_v23.bar.png", height = 7, width = 7)

# Read in the files
prs <- read.table("ARHL_v23.0.5.profile", header=T)
height <- read.table("ARHL.phenotype", header=T)
sex <- read.table("ARHL.cov", header=T)
# Rename the sex
sex$Sex <- as.factor(sex$Sex)
levels(sex$Sex) <- c("Male", "Female")
# Merge the files
dat <- merge(merge(prs, height), sex)
# Start plotting
ggplot(dat, aes(x=SCORE, y=PT, color=PT))+
    geom_point()+
    theme_classic()+
    labs(x="Polygenic Score", y="ARHL")

#prs <- read.table("ARHL_PRSice2.0.001.profile", header=T)
#height <- read.table("ARHL.phenotype", header=T)
#sex <- read.table("ARHL.cov", header=T)
## Rename the sex
#sex$Sex <- as.factor(sex$Sex)
#levels(sex$Sex) <- c("Male", "Female")
## Merge the files
#dat <- merge(merge(prs, height), sex)
# Start plotting
#ggplot(dat, aes(x=SCORE, y=PT, color=PT))+
#    geom_point()+
#    theme_classic()+
#    labs(x="Polygenic Score", y="ARHL")
#
#q() # exit R
