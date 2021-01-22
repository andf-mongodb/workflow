#!/bin/bash

## Progresses through input file line by line, matching for
## portions of the file that resemble:
##
##  private static final Pattern ACCESS_LOG_LINE_PATTERN =
##      Pattern.compile(
##          "^(?<address>\\S*) (\\S*) (\\S*) \\[(?<date>.*)\\]"
##              + " \"(?<method>(GET|POST|PUT|DELETE|PATCH) )?(?<URI>.*)(?<httpVersion> HTTP/.*)?\""
##              + " (?<status>\\d*) (?<length>\\d*) \"(?<referer>.*)\" \"(?<userAgent>.*)\"$");
##
## Identifies component VARIABLE and multiline REGEX PATTERN,
## and outputs them in a manner readily ingestible by other
## tools.

## Set input directory to parse through:
INPUTDIR="/Users/my.username/scripts/"

## Set initial tracking variable to 0:
DO_PATTERN_MATCH=0

## Set bash for loop field separator to newline:
IFS="
"

## Output some custom demarcation so that we can parse later for it:
echo "#######################################################"

## Move line-by-line through source file:
for line in `cat $INPUTDIR/test_api_source_bigone.txt`; do

   ## STEP 1: Check if this line contains VARIABLENAME declariation
   ## matching our criteria:
   if [ `echo $line | egrep -c 'static final Pattern'` -gt 0 ]; then
      VARIABLENAME=`echo $line | egrep 'static final Pattern' | awk -F 'Pattern ' '{print $2}' | sed 's%=%%g'`
      echo $VARIABLENAME

   ## STEP 2: Check if this line contains 'Pattern.compile(' pattern:
   elif [ `echo $line | grep -c 'Pattern.compile('` -gt 0 ]; then


      ## STEP 2.1: Check whether part of the regex to capture is also
      ## on this same line:
      if [ `echo $line | grep -c 'Pattern.compile($'` -gt 0 ]; then

         ## The 'Pattern.compile(' pattern is on its own line. Set
         ## the following variable to jump right to the regex parsing
         ## stanza for next loop:

         DO_PATTERN_MATCH=1

      else

         ## The 'Pattern.compile(' pattern is on a line with all or part
         ## of the regex pattern to match. Check for regex termination
         ## sequence ');' also, to see if this is also the final line
         ## of the regex pattern sequence:

         if [ `echo $line | grep -c ');$'` -gt 0 ]; then

            ## This is, then, the one and only line of the regex pattern.
            ## Print the line as we have it, stripping out the leading
            ## 'Pattern.compile(' invocation, and the trailing ');'
            ## termination sequence so we are left with just the regex:
            echo $line | sed 's%Pattern.compile(%%g' | sed 's%);$%%g'

            ## NOT setting DO_PATTERN_MATCH because this one line has both
            ## begun and ended the regex pattern.

            # Output some custom demarcation so that we can parse later for it:
            echo "#######################################################"

         else

            ## This is not the final line of the regex pattern. Echo what we have
            ## and set DO_PATTERN_MATCH to perform next stanza parsing also:
            echo $line | sed 's%Pattern.compile(%%g'
            DO_PATTERN_MATCH=1

         fi

      fi

   ## STEP 3: We know this line contains part or all of the regex pattern to
   ## match, so output the line (with conditional check):
   elif [ $DO_PATTERN_MATCH -eq 1 ]; then

      ## STEP 3.1: Check if this line in the regex pattern contains the
      ## regex pattern termination sequence ');', and if so reset the tracking
      ## variable to start looking for a fresh VARIABLENAME next loop"
      if [ `echo $line | grep -c ');$'` -gt 0 ]; then

         ## Termination sequence found. Print line as we have it, but
         ## strip termination sequence to output just the regex:
         echo "$line" | sed 's%);$%%g'

         ## Reset so that we are now looking for the start of the next
         ## VARIABLENAME declaration next loop:
         DO_PATTERN_MATCH=0

         ## Output some custom demarcation so that we can parse later for it:
         echo "#######################################################"

      else

         ## No termination sequence found, so just output the line as we
         ## have it. Next loop will progress to the next line in sequence:
         echo "$line"

      fi
       
   fi

done
