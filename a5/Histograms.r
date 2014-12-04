# Import Data
bar <- read.delim("http://alictai.github.com/bardata.csv", sep=",", col.names=c("ParticipantID", "Index", "Vis", "VisID", "Error", "TruePerc", "ReportPerc"), skip = 0, header=TRUE)
pie <- read.delim("http://alictai.github.com/piedata.csv", sep=",", col.names=c("ParticipantID", "Index", "Vis", "VisID", "Error", "TruePerc", "ReportPerc"), skip = 0, header=TRUE)

# Set array for two plots to show in a 2x1 grid
par(mfrow = c(2,1))

# Generate histograms
hist(bar$Error, xlab="Log Error", main="Histogram for Bar Chart Log Error ", xlim=c(-10,10), freq=F, col="coral")
lines(dnorm(bar$Error,mean(bar$Error),sd(bar$Error)),lwd=2,lty=2)
hist(pie$Error, xlab="Log Error", main="Histogram for Pie Chart Log Error ", xlim=c(-10,10), freq=F, col="lightblue")
lines(dnorm(0:72,mean(pie$Error),sd(pie$Error)),lwd=2,lty=2)
dnorm(pie$Error,mean(pie$Error),sd(pie$Error))
