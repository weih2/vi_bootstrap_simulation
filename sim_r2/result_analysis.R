library(ggplot2)

# show(result)
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
#  949  954  950  948  949  944  933  952 0.00
# 948  951  940  959  923  924  925  938 0.05
# 937  941  933  953  920  934  924  948 0.10
#  931  938  934  953  944  944  936  947 0.15
# 939  939  948  946  937  941  927  937 0.20
# 953  953  951  949  939  941  932  935 0.25
#  938  943  936  946  940  932  933  946 0.30
#  931  942  929  947  951  957  933  951 0.35
# 935  938  929  951  941  939  915  950 0.40
#   938  938  918  952  946  953  887  953 0.45
#  943  943  926  948  940  941  900  949 0.50
#   946  947  907  948  955  957  901  943 0.55
#  948  948  913  953  960  967  907  955 0.60
# 950  945  876  954  945  949  858  946 0.65
#  938  942  883  950  957  958  870  953 0.70
#  945  949  850  954  950  957  826  948 0.75
# 933  939  856  945  962  971  818  952 0.80
#  944  949  813  951  948  967  763  947 0.85
#   947  950  788  951  932  967  697  945 0.90
#  933  934  730  953  920  954  596  948 0.95

# save(result, file = "result.file")
load("result.file")

result.1 = (result[, 1:4])/1000
result.1 = as.numeric(result.1)

result.lab = rep(c("vwlb_cs", "vwlb_cs2", "vp", "empirical"), each = 20)
result.x.lab = seq(0, 0.95, by = 0.05)

result1.df = data.frame(coverage = result.1, lab = result.lab, 
                       auto.cor = result.x.lab)

# color
ggplot(data = result1.df, 
       mapping = aes(x = auto.cor, y = coverage, color = lab)) + geom_line()

# linetype
ggplot(data = result1.df, 
       mapping = aes(x = auto.cor, y = coverage, linetype = lab)) + geom_line()
