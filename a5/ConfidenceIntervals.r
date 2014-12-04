# PUT POPULATION SIZE HERE
n <- 6

labels <- array(1:n)
labels[1] = "large bar chart"
labels[2] = "medium bar chart"
labels[3] = "tiny bar chart"
labels[4] = "large pie chart"
labels[5] = "medium pie chart"
labels[6] = "tiny pie chart"

x <- numeric(n)
# PUT REAL DATA HERE (Log Errors of each Visualization)
x[1] = 1.24	# large bar
x[2] = 1.62	# tiny bar
x[3] = 0.95	# medium bar
x[4] = 2.05	# large pie
x[5] = 1.90	# medium pie
x[6] = 2.21	# tiny pie

mu <- mean(x)
sig <- sd(x)

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

plot(1,1,xlim=c(min(lcl), max(ucl)),ylim=c(1,n+1),type='n', main = "100 95% Confidence Intervals of Log Error", xlab="Log Error", ylab="Trial")

#legend('bottomright', c("Hit", "Miss"), bg="white", fill=c("coral", "cornflowerblue"))

for (i in 1:n) {
	#if (mu <= ucl[i] & lcl[i] <= mu) {
	#	lines(c(lcl[i],ucl[i]),c(i,i), col="coral")
    #} else {
    	#	lines(c(lcl[i],ucl[i]),c(i,i), col="cornflowerblue")
    #}   
    lines(c(lcl[i],ucl[i]),c(i,i), col="cornflowerblue")
    points(x[i],i,pch=16,cex=.5) 
    text(x[i],i, labels[i], 3, 3)
}
#abline(v=mu,lty=2, col="black")
hits
