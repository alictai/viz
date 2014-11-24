x <- numeric(n)

#PUT REAL DATA HERE (Log Errors of each Visualization)
x[1] = 1		# small bar
x[2] = 1.5	# medium bar
x[3] = 3		# large bar
x[4] = 2.0	# small pie
x[5] = 1.3	# medium pie
x[6] = 1.4	# large pie

mu <- mean(x)
sig <- sd(x)
n <- 6

z <- qnorm(.975)  
hits <- 0  
ucl <- numeric(n) 
lcl <- numeric(n) 


for (i in 1:n) {
    #x[i] <- mean(rnorm(n,mu,sig))  # i-th sample mean
    lcl[i] <-(x[i]) - z*sig/sqrt(n)  
    ucl[i] <-(x[i]) + z*sig/sqrt(n)  
    hits <- hits + (mu <= ucl[i] & lcl[i] <= mu)
   }

plot(1,1,xlim=c(min(lcl), max(ucl)),ylim=c(1,n),type='n', main = "100 95% Confidence Intervals of Log Error", xlab="Log Error", ylab="Trial")

legend('bottomright', c("Hit", "Miss"), bg="white", fill=c("coral", "cornflowerblue"))

for (i in 1:n) {
	if (mu <= ucl[i] & lcl[i] <= mu) {
		lines(c(lcl[i],ucl[i]),c(i,i), col="coral")
    } else {
    		lines(c(lcl[i],ucl[i]),c(i,i), col="cornflowerblue")
    }   
    points(x[i],i,pch=16,cex=.5,) 
}
abline(v=mu,lty=2, col="black")
hits
