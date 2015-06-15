# erepost
Stata module to repost the estimation results

erepost changes the b or V matrix of the current estimation results or changes the declared estimation sample. erepost is similar to official ereturn repost. However, erepost is allowed after estimation commands that do not post their results using -ereturn post- (e.g. logit) and erepost can be used outside of eclass programs.

To install the erepost package, type

. ssc install erepost, replace

in Stata. Stata version 8.2 or newer is required.
