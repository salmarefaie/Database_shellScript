#!/usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob

# metadata for table
col_selectArr=($(head -1 ./$selectTable"_metadata" | awk -F : '
   {
            fields=split($0, arr); 
            for (i=0;i<=fields;i++) print arr[i] 
   }

' ))

# num of columns for table
numSelectColumns=$(head -1 ./$selectTable"_metadata" | awk -F : '
{
      print NF
}
' )

# take id or name or ....
read -p "Enter name column which is selected row by it: " column

# check regex column name
if [[ -z $column || $column == [0-9]* || $column == *['!''@#/$\"*{^(+/|,;:~`.%&.=-]>[<?']* || $column == *" "* ]] ;then
   echo " ---------------------- "
   echo "| Inavalid Column Name |" 
   echo " ---------------------- "

declare -i index         # num of column for table

# check lw mwgood fy table metadata
elif [[ ${col_selectArr[*]} =~ $column ]] ; then

      # bageeb num of column for table
      for (( i=1; i <= $numSelectColumns ; i++ ))
      do 
         if [[ "${col_selectArr[i-1]}" == "$column" ]] ; then
            index=$i
         fi
      done
      
      # select colomn values
      echo " ------ "
      echo "| ${col_selectArr[index-1]} |"
      echo " ------ "
      cat ./$selectTable | cut -d":" -f $index
      
# column name m4 mwgood
else
   echo " ---------------------- "
   echo "| Column doesn't Exist |"
   echo " ---------------------- "

fi
break