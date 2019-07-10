# result.coverage = scan()

result.lab = rep(c("vwlb_cs", "vwlb_cs2", "vp", "empirical"), each = 100)
result.x.lab = seq(0.1, 10, by = 0.1)

result.df = data.frame(coverage = result.coverage, lab = result.lab, 
                       x.lab = result.x.lab)
library(ggplot2)
# color
ggplot(data = result.df, 
       mapping = aes(x = x.lab, y = coverage, color = lab)) + geom_line()

# linetype
ggplot(data = result.df, 
       mapping = aes(x = x.lab, y = coverage, linetype = lab)) + geom_line()
