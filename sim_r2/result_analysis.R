library(ggplot2)


result.lab = rep(c("vwlb_cs", "vwlb_cs2", "vp", "empirical"), each = 10)
result.x.lab = seq(0.1, 10, by = 0.1)

result.df = data.frame(coverage = result.coverage, lab = result.lab, 
                       delta = result.x.lab)

# color
ggplot(data = result.df, 
       mapping = aes(x = delta, y = coverage, color = lab)) + geom_line()

# linetype
ggplot(data = result.df, 
       mapping = aes(x = delta, y = coverage, linetype = lab)) + geom_line()