x.axis = log(c(100, 200, 500, 1000, 2000))

mean.sigma2.est = apply(sigma2.est, 1, mean)

# mean.sigma2.vb.est = c(mean.sigma2.vb.est, mean(scaned.data))

mean.abs.error 

plot(x.axis, apply(mean.abs.error2, 1, mean) * sqrt(c(100, 200, 500, 1000, 2000)),
     ylim = c(3, 4))

plot(x.axis, (mean.sigma2.est / mean.sigma2.vb.est), ylim = c(0.9, 1.2))
abline(h = 1)


plot1.df = data.frame(x.ax = x.axis, normalized.error = apply(mean.abs.error2, 1, mean) * sqrt(c(100, 200, 500, 1000, 2000)))
ggplot(data = plot1.df, mapping = aes(x = x.ax, y = normalized.error)) + geom_line() + geom_point() + ylim(3, 4) + 
  xlab("log n") + ylab(expression(
    paste("averaget of ", sqrt(n),"||", mu[i] - mu,"||"[infinity] )))

plot2.df = data.frame(x.ax = x.axis, ratio = (mean.sigma2.est / mean.sigma2.vb.est) )
ggplot(data = plot2.df, mapping = aes(x = x.ax, y = ratio)) + geom_line() + geom_point() +
  ylim(0.9, 1.2) + xlab("log n") + ylab(expression(
    paste(
      hat(sigma)^2,
      "/",
      s^2,
    )
  ))
