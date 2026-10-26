

require(StratifiedSampling)

library(StratifiedSampling)
#  Construction of the data frame donn_som for 4x4x2 three-way table
# The goal is to test the fit of model [12] [13] [23] of no third order interaction
donn_som<-expand.grid(foll=c(10,20,30,60),init=c(10,20,30,60),trt=c(1,2))
donn_som$y<-c(7,4,1,0,11,5,2,2,13,23,3,1,9,17,13,8,7,4,2,1,14,5,1,0,6,9,18,2,4,11,14,22)
N=sum(donn_som$y)#  The total frequency is 239
n<-nrow(donn_som) # The length of the data vector is 32
#  Create factors
donn_som$foll<-as.factor(donn_som$foll);donn_som$init<-as.factor(donn_som$init);
donn_som$trt<-as.factor(donn_som$trt);
# Poisson regression for the model without third order interaction
xxp<-glm(y~(foll+init+trt)^2,data=donn_som,family=poisson)
#  Calculation of the vector of predicted values \hat y_i defined after equation (2) 
yhat<-predict.glm(xxp,type="response")
# Output for the Poisson regression
summary(xxp)
# The residual deviance is 17.49
1-pchisq(summary(xxp)$deviance,df=9)
#  The p-value calculated with the chi-square 9 limiting distribution is 4.2%  
#  The matrix X defined in Section 2.1 is 
matM<-model.matrix(~(foll+init+trt)^2,data=donn_som)
# its size is 32*23
##############################################################
# Implementation of the cube method of sections 4.1 and 4.2
#  
#Creation of population E^{\ell N} of section 4.1 for \ell=1 with n*N=7648 elements
UN<-kronecker(diag(n),t(rep(1,N)))
#constraint matrix A^(1) of Section 4.2.  
A0<-numeric(0)
for (i in (1:n)){
  A0<-cbind(A0, outer(matM[i,],rep(1,N)))
}
#dim(A0)  23 7648
# Selection probability vector \Pi ^{(1)}of Section 4.2
prob<-rep((yhat/N), each=N)
#  Construction of a matrix, res,  with B simulated vectors y^{(b)} 
#  The function ffphase implements the flight phase of the cube as described in Section 4.2
B=2000
# B=2000 gives a 95% Monte Carlo margin of error of 1.96*sqrt(.05*.95/2000)=0.01 
#  This runs in about 3 minutes on my computer;  put B=100 if you want to have a result quickly 
set.seed(234571)
temp1<-Sys.time()
res<-numeric(0)
for (i in (1:B))
{
  xx<-prob
  # the next line rejects results of the flight phase that are not 0-1 vectors
  while(!all(abs(xx - round(xx)) <= .001))
  xx<-ffphase(t(A0)*prob,prob)
  # the simulated vector y^{(b)} calculated with formula (10) is added to the result matrix
  res<-rbind(res,as.vector(UN%*%xx))
}
temp2<-Sys.time()
temp2-temp1

#  Function to calculate the deviance G_b^2 in equation (4)
calc_dev<-function(ysim){
dat_obs<-donn_som; dat_obs$y<-ysim
fit_obs   <- glm(y ~ (foll + init + trt)^2, data = dat_obs, family = poisson())
dev_obs   <- fit_obs$deviance
dev_obs}
#  Calculate the deviances for the B simulated samples
dev<-apply(res,1,calc_dev)

#Exact p-value calculated using formula (4)

mean(dev>summary(xxp)$deviance)  + mean(dev==summary(xxp)$deviance)/2 # 0.1095

