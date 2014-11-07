#!/bin/bash

#script for displaying infromation conncetd about peripheral devices


echo "Detecting system"
echo "."
echo ".."
echo "..."
echo "...."
echo "Welcome `uname -a`"
echo -n "Enter your username for proceeding:-"
read username
#echo $USER
if [ $username == $USER ]
then
echo "|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\|"
echo "|------------------------------------------------------------------------------------|"
echo "|------------------------------------------------------------------------------------|"
echo "|-------------------------------|||||||||||||||||||||||------------------------------|"
echo "|-------------------------------|  WELCOME  $username |------------------------------|"
echo "|-------------------------------|||||||||||||||||||||||------------------------------|"
echo "|------------------------------------------------------------------------------------|"
echo "|------------------------------------------------------------------------------------|"
echo "|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\|"


#getting log into the text file
cat /var/log/syslog |grep usb >log.txt
cat /var/log/syslog.?|grep usb >>log.txt
zcat /var/log/syslog.?.gz |grep usb >>log.txt
term=0

#function for general time input
function call {
          echo "***-------------------------------***"
          echo "---Welcome to time format chooser----"
          echo "***-------------------------------***"
          echo "||->Enter (a) For Displaying Month Info"
          echo "||->Enter (b) For Displayimg Month and Day Info"
          echo "||->Enter (c) For Displaying Month Day and Hour Info"
          echo -n "||-<Enter choice:-"
          read choice1

          case $choice1 in
          
           a)   echo -n "Please enter time format(month):-"
                read time1
           ;;

           b)   echo -n "enter time format(month[space][space]date ):-"
                read time1
           ;;

           c)  echo -n "enter time format(month[space][space]date[space] hour):-"
                read time1
           ;;

           *) echo "Please enter the correct choice :"
           ;;
          esac

}

while [ $term -ne 1 ]
do
   echo "Services--------------->"
   echo "||->Enter 1 for finding the no. of devices connected in specified time interval:"
   echo "||->Enter 2 for finding out the product and manufacturer that are conncted at time :"
   echo "||->Enter 3 for knowing the log of serial devices :"
   echo "||->Enter 4 for knowing The product connectivity info:"
   echo "||->Enter 5 for Knowing the files transferred from USB:"
   echo "||->Enter 6 for USB tracking :"
   echo "||->enter quit for logging off"
   echo -n "||-<Enter choice:-"
   read choice;

   #got the choice here now applying switch condition
   case $choice in
   
   1)   
          echo "Enter the time  to know how many usb devices were connected"
          call   #calling function for time interval  input
          #grep 'Apr 8' log.txt 
          #grep "$time1" log.txt| grep 'SerialNumber:'| awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}' >>device1.txt
          #grep 'SerialNumber:' device1.txt
          echo $time1
               #grep "$time1" log.txt| grep 'SerialNumber:'
               #grep "$time1" log.txt| grep 'SerialNumber:'| awk -F ":" '{print $NF}' |sort -u
          echo "The no. of devices are:-"
          grep "$time1" log.txt| grep 'SerialNumber:'| awk -F ":" '{print $NF}' | sort -u | wc -l
          #echo $mnth1
    ;;

    2)    

           echo "Enter the time  to knowing the device manufacture and product"
           call  #calling function for time interval input
           grep "$time1" log.txt> log1.txt
           grep -B 1 Manufacturer log1.txt >out1.txt  #getting manufacturer information in ou1.file
           `sed '/--/d' ./out1.txt >manf.txt`  #removing unwanted character from file
           grep -B 1 Manufacturer manf.txt | awk -F ":" '{print $(NF-1) $NF}' >outinfo.txt
           echo "------------------------------------------------------------------"
           echo "-----------Displaying product manufacturer Info-------------------"
           echo "------------------------------------------------------------------"
            awk 'NR%2{printf $0" ";next;}1' outinfo.txt | sort -u 
           echo "------------------------------------------------------------------"
           echo $mnth1  #debug
    ;;

    3)
          echo "Wait a minute it will be print the serial log"
          #running the python script
          python serial.py
          echo "wait over now displaying information "
          cat serial-log.txt
    ;;

    4)
        echo "Displaying the no. of products which are conncted "
        grep -B 1 Manufacturer log.txt | awk -F ":" '{print $(NF-1) ":" $NF}' >productsee.txt
       `sed '/--/d' ./productsee.txt >psee.txt`  #removing unwanted character from file
        index=0
        #awk 'NR%2{printf $0":";next;}1":"' psee.txt
        awk 'NR%2{printf $0":";next;}1' psee.txt | sort -u |while IFS=":" read t1 t2 t3 t4
        do
              index=`expr $index + 1`
              echo "Product[$index]:-$t2"
        done  
        echo -n "Now Enter the product name from the displayed list:-"
        read product
        counter=0
        var=true
        echo "|-------------Displaying Activity Log-------------------|"
        echo "|-------------------------------------------------------|"
        grep "Product: $product" log.txt | while read t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
        do
           #as here we need to displat the time stamp system name and usb port
           #so choose temp variables t1 t2 t3 t4 t7 and t8
           echo "----Activity $counter"
           echo "------Date :-$t2-$t1"
           echo "------Time :-$t3"
           echo "------Computer Name :-$t4"
           echo "------Usb Port:-$t7$t8"
           var=false
           counter=$((counter + 1))
        done 
        echo "|-------------------------------------------------------|"
                 
    ;;
    5)
         echo "|------Welcome to File Tranfer Activity Log service----|"
         echo "|------------------------------------------------------|"
         echo "||-> Enter 1 for Mounting the usb device "
         echo "||-> Enter 2 for Removing the usb device "
         echo "||-> Enter 3 for Knowing the file transferred from usb"
         echo -n "||-> Enter yout choice "
         read choice1
         #declare -A matrix
         #num_rows=4
         #num_columns=2
         case $choice1 in

          1) echo -n "Enter the name of usb device you want to mount:-"
             read usbName
             fullname="/media/$usbName"
             `mount $fullname`
             usbName=$usbName.1
             usbsize=$usbnema.s.1
            # ls  -s $fulln |grep total | awk '{print $2}'
             echo $usbName      
             echo `ls -R -f $fullname | cat > $usbName.txt` 
             
           ;;
          2) echo -n "Enter name of usb u want to unmount:- "
             read uname
             fullname1="/media/$uname"
             uname=$uname.2
             echo `ls -R -f $fullname1| cat >$uname.txt`
             `umount $uname`
           ;;
          3) echo -n "Enter the USB name for which you want transfer log:- "
             read name
             vari1=$name.1
             vari2=$name.2
             echo "--------------------------------------------------------"
             echo "--------------Displaying Log ---------------------------"
             echo "--------------------------------------------------------"
             echo "The file which are transferred are --->"
             #echo $vari1 
             echo `diff $vari1.txt $vari2.txt ` 
              # cat outnow.txt
          
          
          esac
            
         
    ;;

    6)
         #python devicetracker.py
         echo "Information will be displayed as soon as you will plug a usb device"
         python devicetracker.py

    ;;

    7)
         echo "|------Welcome to File Tranfer Activity Log service1----|"
         echo "|------------------------------------------------------|"
         echo "||-> Enter 1 for Mounting the usb device "
         echo "||-> Enter 2 for Removing the usb device "
         echo "||-> Enter 3 for Knowing the amount of data transferred from usb"
         echo -n "||-> Enter yout choice "
         read choice1
         #declare -A matrix
         #num_rows=4
         #num_columns=2
         case $choice1 in

          1) echo -n "Enter the name of usb device you want to mount:-"
             read usbName
             fullname="/media/$usbName"
             `mount $fullname`
             usbName=$usbName.1
             usbsize=$usbnema.s.1
            # ls  -s $fulln |grep total | awk '{print $2}'
             echo $usbName      
             echo `ls -R -f $fullname | cat > $usbName.txt` 
             
           ;;
          2) echo -n "Enter name of usb u want to unmount:- "
             read uname
             fullname1="/media/$uname"
             uname=$uname.2
             echo `ls -R -f $fullname1| cat >$uname.txt`
             `umount $uname`
           ;;
          3) echo -n "Enter the USB name for which you want transfer log:- "
             read name
             vari1=$name.1
             vari2=$name.2
             echo "--------------------------------------------------------"
             echo "--------------Displaying Log ---------------------------"
             echo "--------------------------------------------------------"
             echo "The file which are transferred are --->"
             #echo $vari1 
             echo `diff $vari1.txt $vari2.txt ` 
              # cat outnow.txt
          
          
          esac
            
         
    ;;
    quit)
          term=1;
    ;;

    esac
done

else 
 echo "Your usernaem is not verified please insert correct usrename "
fi
