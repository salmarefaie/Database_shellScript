#!/usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob

# metadata for table
col_DeleteArr=($(head -1 ./$DeleteTable"_metadata" | awk -F : '
   {
            fields=split($0, arr); 
            for (i=0;i<=fields;i++) print arr[i] 
   }

' ))

# num of columns for table
numDeleteColumns=$(head -1 ./$DeleteTable"_metadata" | awk -F : '
{
      print NF
}
' )

# metadata datatype for table
colDeleteArr_type=($(tail -1 ./$DeleteTable"_metadata" | awk -F : '
   {
            fields=split($0, arr); 
            for (i=0;i<=fields;i++) print arr[i] 
   }

' ))

# take id or name or ....
read -p "Enter name column which is selected row by it: " columnDelete

# check regex column name
if [[ -z $columnDelete|| $columnDelete = [0-9]* || $columnDelete = *['!''@#/$\"*{^({+/|,};:~)`.%&.=-]>[<?']* || $columnDelete = *" "* ]] ;then
   echo " ---------------------- "
   echo "| Inavalid Column Name |" 
   echo " ---------------------- "


declare -i index_delete        # num of column for table
declare -i index_deletevalue   # num of row which is deleted
declare -a search_deleterow    # array elly h7d feha values bta3t column da  
declare -a index_value         # 3shan lw 3ndy kza row 3ndohm nfs el condition (array feha index)

# check lw mwgood fy table metadata
elif [[ ${col_DeleteArr[*]} =~ $columnDelete ]] ; then

    # bageeb num of column for table
    for (( i=1; i <= $numDeleteColumns ; i++ ))
    do 
      if [[ "${col_DeleteArr[i-1]}" == "$columnDelete" ]] ; then
          index_delete=$i
      fi
    done
    
    # h7od el values btta3t column da fy array
    delete=`cat ./$DeleteTable | cut -d":" -f $index_delete`
    echo $delete > column
    delete_row=($(cat ./column | awk '
   {
            fields=split($0, arr); 
            for (i=0;i<=fields;i++) print arr[i] 
   }

' ))
  rm column

  #echo ${delete_row[*]}

  #  take value of column to delete this row
  read -p "Enter value of column which is selected row by it: " column_deletevalue
  if [[ -z $column_deletevalue || $column_deletevalue = *['!''@#/$\"*{^({+/|,};:~)`.%&.=-]>[<?']* || $column_deletevalue = *" "* ]] ;then
   echo " ------------------------------- "
   echo "| Inavalid Value of Column Name |" 
   echo " ------------------------------- "
  

  
  # bageeb num of row and delete it
  elif [[ ${delete_row[*]} =~ $column_deletevalue ]] ; then
   for (( i=0; i < ${#delete_row[*]} ; i++ ))
   do 
         if [[ "${delete_row[i]}" == "$column_deletevalue" ]] ; then
               (( index_deletevalue=$i+1 ))
               echo $index_deletevalue
               index_value+=($index_deletevalue)
         fi
         
   done

   #echo ${index_value[*]}
   #echo ${#index_value[*]}

   # bayyyyyyzaaaa
   <<Comment
   for (( i=0; i < ${#index_value[*]} ; i++))
   do
      
       sed -i ''$line'd' ./$DeleteTable
   done
Comment
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

unset index_value[@]
