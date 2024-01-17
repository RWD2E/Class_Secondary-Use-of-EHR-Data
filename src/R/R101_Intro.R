##################################################################
#Basic Syntax                             
#This script is to introduce some basic syntax and grammar of R                  
##################################################################

#=====Variable Assignment=====
x<-4
y=2
z<-x+y

z
print(z)

x<-"a"
y<-"b"
z<-x+y # will get error
z<-paste(x,y)
z

#=====Variable Comparison, Logical=====
x==y
x!=y
x>y
x>=y
x<=y


#=====Math function=====
x+y
x-y
x*y
x/y
x^2
sqrt(x)
log(x,2) 
log(x) #default at natural log

#=====Logic function=====
x<-TRUE
y<-FALSE

x&y
x|y


#=====R Data Types=====
#---Numeric
n<-15 # Double precision by default
n
typeof(n)

n<-15L # Integer
n
typeof(n)

#---Character / String
c1 <- "c"
c1
typeof(c1)

c2 <- "a string of text"
c2
typeof(c2)

#---Logical
l1<-TRUE
l1<-T

l2<-FALSE
l2<-F


#=====R Data Structure=====
#---Vector
v1 <- c(1, 2, 3, 4, 5)
v1
is.vector(v1)

v1<-1:10
v1

v2 <- c("a", "b", "c")
v2

v2<-letters[1:12]
v2

v3 <- c(TRUE, TRUE, FALSE, FALSE, TRUE)
v3

v4<-c("a",1,TRUE)
v4

#---Matrix
m1 <- matrix(1:8,
             nrow = 2,
             byrow=T)
m1
is.matrix(m2)

m2 <- matrix(1:8,
             nrow = 2,
             byrow=F)
m2

m2_row1<-m2[1,]
m2_col1<-m2[,1]


#---Data Frame
df<-data.frame(vNumeric=c(1, 2, 3),
               vCharacter=c("a", "b", "c"),
               vLogical=c(T, F, T))
df
is.data.frame(df)
is.matrix(df)


df_row1<-df[1,]

#print first two rows
df[1:2,]
df[c(1,3),]

df_col1<-df[,1]
df[,2:3]

df[1,3]
df[,c(1,3)]

m1[,c(2,4)]


df_col_vNumeric<-df[,"vNumeric"]
df_col_vNumeric<-df$vNumeric


#---List
o1 <- c(1, 2, 3)
o2 <- c("a", "b", "c", "d")
o3 <- c(T, F, T, T, F)

list1 <- list(o1=o1, 
              o2=o2, 
              o3=o3)
list1

list2 <- list(o1=o1,
              o2=o2,
              o3=o3, 
              o4=list1)  # Lists within lists!
list2

list1_o1<-list1["o1"]


#=====R Comments======
# Use # signs to comment. Anything to the right of a # is ignored by R, meaning it won't be executed. 
# Comments are a great way to describe what your code does within the code itself, 
# so comment liberally in your R scripts.







