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

# metadata datatype for table
colSelectArr_type=($(tail -1 ./$selectTable"_metadata" | awk -F : '
   {
            fields=split($0, arr); 
            for (i=0;i<=fields;i++) print arr[i] 
   }
' ))

# take id or name or ....
read -p "Enter name column which is selected row by it: " column

exist_column=""
for element in ${col_selectArr[*]}
do 
    if [ $element = $column ] ; then
        exist_column=$element
    fi
done

exist_field=""
for element in ${col_selectArr[*]}
do 
    if [ $element = $field ] ; then
        exist_field=$element
    fi
done

# check regex column name
if [[ -z $column || $column = [0-9]* || $column = *['!''@#/$\"*{^(+/|,;:~`.%&.=-]>[<?']* || $column = *" "* ]] ;then
   echo " ---------------------- "
   echo "| Inavalid Column Name |" 
   echo " ---------------------- "

declare -i index         # num of column for table

# check lw mwgood fy table metadata
elif [[ $exist_column = $column ]] ; then

      # bageeb num of column for table
      for (( i=1; i <= $numSelectColumns ; i++ ))
      do 
         if [[ "${col_selectArr[i-1]}" == "$column" ]] ; then
            index=$i
            type=${colSelectArr_type[$index-1]}
         fi
      done

      # take value of column to select this row
      read -p "Enter value of column which is selected row by it: " column_value

      # check type to take true value
      if [[ "$type" = "int" ]] ;then

         while [[ $column_value == +([0]) || $column_value != +([0-9]) ]]
         do 
         read -p " Invalid Value, you should enter an integer value: " column_value
         done

         row_num=`awk -F : '
            {
               if($'$index'=='$column_value'){print NR}
            }
            ' "./$selectTable"` 
         

      elif [[ "$type" == "string" ]] ;then
         while [[ -z $column_value || $column_value = [0-9]* || $column_value = *['!''@#/$\"*{^({+/|,};:~)`.%&.=-]>[<?']* || $column_value = *" "* ]]
         do 
         read -p " Invalid Value, you should enter a string value: " column_value
         done

         row_num=`awk -F : '
            {
               if($'$index'=="'$column_value'"){print NR}
            }
            ' "./$selectTable"` 
      fi

      if [[ ! -z $row_num ]] ; then

            declare -i field_index         # num of column for table
            read -p "Enter name column which is selected in the row: " field

            if [[ -z $field || $field = [0-9]* || $field = *['!''@#/$\"*{^(+/|,;:~`.%&.=-]>[<?']* || $field = *" "* ]] ;then
               echo " ---------------------- "
               echo "| Inavalid Column Name |" 
               echo " ---------------------- "

            # check lw mwgood fy table metadata
            elif [[ $exist_column = $column ]] ; then

               # bageeb num of column for table
               for (( i=1; i <= $numSelectColumns ; i++ ))
               do 
                  if [[ "${col_selectArr[i-1]}" == "$field" ]] ; then
                     field_index=$i
                  fi
               done
               echo " -------------------------- "
               echo "| Data From Selected Field |"
               echo " -------------------------- "
               sed -n '1p' "$selectTable"_metadata"" | cut -d":" -f $field_index
               echo ""
               sed -n ''$row_num' p' ./$selectTable | cut -d":" -f $field_index

            # column name m4 mwgood
            else
               echo " ---------------------- "
               echo "| Column doesn't Exist |"
               echo " ---------------------- "
            fi
      else
      echo " ------------------------------- "
      echo "| Value of Column doesn't Exist |"
      echo " ------------------------------- "
      fi  

   
# column name m4 mwgood
else
   echo " ---------------------- "
   echo "| Column doesn't Exist |"
   echo " ---------------------- "

fi
break