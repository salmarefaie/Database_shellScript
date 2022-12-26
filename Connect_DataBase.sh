#!/usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob

echo " --------------------- "
echo "| Database Connection |"
echo " --------------------- "
ls -F | grep "/"
read -p "Enter your database name: " databaseName


if [[ -z $databaseName || $databaseName == [0-9]* || $databaseName == *['!''@#/$\"*{^(+/|,;:~`.%&.=-]>[<?']* || $databaseName == *" "* ]] ;then
   echo "  ---------------------- "
   echo "| Inavalid Databse Name |"
   echo "  ---------------------- "

elif [ -e $databaseName ] ;then
   cd ./$databaseName 
   
   echo " ------------ "
   echo "| Table Menu |"
   echo " ------------ "

   select option in "Create Table" "List Tables" "Insert Table" "Select Table" "Update Table" "Drop Table" "Delete Table" "Database Menu"
   do
	case $option in
	
		"Create Table" )	
		    source ../../Create_Table.sh
	        ;;
	        
		"List Tables" )
		    source ../../List_Tables.sh
	        ;;
	        
		"Insert Table" )  
		    source ../../Insert_Table.sh
		;;

		"Select Table" )
		    source ../../Select_Table.sh
		;;
		
		"Update Table" )
		    source ../../Update_Table.sh
		;;
		
		"Drop Table" )
		    source ../../Drop_Table.sh
		;;
		
		"Delete Table" )
		    source ../../Delete_From_Table.sh
		;;
		
		"Database Menu" )
		 echo "  -------------------- "
		 echo " | Your Database Menu |"
		 echo "  -------------------- "
		 cd ..
		 break
	    ;;
	esac

    done 
else 
      echo " ------------------------ "
      echo "| Database doesn't exist |"
      echo " ------------------------ "
fi



