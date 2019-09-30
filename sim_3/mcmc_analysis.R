coverage1 <- scan()
570 998 596
613 997 604
631 998 623
639 1000  628
671 998 680
682 999 683
710 999 707
705 997 711
769 998 742
797 998 785
791 1000  822
848 998 852
851 997 874
893 998 868
902 1000  903
920 998 926
949 1000  959
950 999 970
966 999 965
970 999 970
985 1000  980
977 1000  984
984 1000  985
990 1000  987
992 1000  986
983 999 982
989 999 985
979 998 975
972 998 985
961 998 970
975 993 968
965 985 963
958 985 943
959 977 955
940 943 945
956 946 938
924 942 936
935 940 933
954 945 954
935 947 949
939 949 936
943 926 952
941 947 943
949 940 958
931 955 929
946 951 940
932 948 946
951 947 944
947 946 931
937 957 929
948 938 937

coverage2 <- scan()
599 999 564
612 999 584
627 1000  651
679 1000  633
690 1000  665
721 998 696
758 998 714
772 1000  758
806 1000  798
834 1000  852
872 997 854
886 999 873
919 1000  916
914 1000  926
942 998 924
959 1000  950
961 1000  959
979 1000  975
968 1000  976
978 999 986
982 1000  990
990 999 982
986 1000  992
989 1000  990
984 999 986
982 1000  984
976 1000  985
975 998 974
973 993 970
980 994 963
969 982 973
950 982 960
956 960 958
946 959 934
935 930 926
941 933 941
951 940 954
941 935 945
942 940 931
941 932 938
936 942 948
947 945 954
958 954 940
955 945 922
946 938 947
930 947 947
950 966 943
941 956 949
952 941 949
945 945 948
930 954 948

coverage1 = rowMeans(matrix(coverage1, nrow = 51, byrow = T)/1000)
coverage2 = rowMeans(matrix(coverage2, nrow = 51, byrow = T)/1000)



coverage1 = as.numeric(matrix(coverage1, nrow = 51, byrow = T))/1000
coverage2 = as.numeric(matrix(coverage2, nrow = 51, byrow = T))/1000

N = c(rep("100 obs", 153), rep("200 obs", 153))
coverage.all = c(coverage1, coverage2)

result.lab = rep( c("cluster 1", "cluster 2", "cluster 3"), each = 51)

result1.df = data.frame(coverage = coverage1, cluster = result.lab, 
                        delta = test.seq)

result.df.all = data.frame(coverage = coverage.all, cluster = result.lab, 
                           delta = test.seq, N = N)
ggplot(data = result1.df, 
       mapping = aes(x = delta, y = coverage, color = cluster)) + geom_line() +
  theme_grey(base_size = 25)

ggplot(data = result.df.all,
       mapping = aes(x = delta, y = coverage, color = cluster)) + geom_line() +
  theme_grey(base_size = 25)+ facet_wrap(~N)

