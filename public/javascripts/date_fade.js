function validate_form_edit()
	{
	  validedit=true;
	  a=document.forms["demoedit"].DPC_calendar1;
	  var da = new Date();
	  var d = da.getDate();
      var c_month = da.getMonth();
      var m=c_month+1;
      var y = da.getFullYear();
      var sdt = document.forms["demoedit"].DPC_calendar;
      var edt = document.forms["demoedit"].DPC_calendar1;
      var sd=new String(sdt.value);
      var ed=new String(edt.value);
      if (sd.substring(0,1) == 0) {
	  	var sdate = parseInt(sd.substring(1, 2));
	  }
	  else {
	  	var sdate = parseInt(sd.substring(0, 2));
	  }
      if (ed.substring(0,1) == 0) {
	  	var edate = parseInt(ed.substring(1, 2));
	  }
	  else {
	  	var edate = parseInt(ed.substring(0, 2));
	  }
	  
	  if (sd.substring(3,4) == 0) {
	 
	  	var smonth = parseInt(sd.substring(4, 5));
	  	
	  }
	  else {
	  	var smonth = parseInt(sd.substring(3, 5));
	  }
      if (ed.substring(3,4) == 0) {
	  	var emonth = parseInt(ed.substring(4, 5));
	  }
	  else {
	  	var emonth = parseInt(ed.substring(3, 5));
	  }
	  
	  
      
      var syear=parseInt(sd.substring(6,10));
      var eyear=parseInt(ed.substring(6,10));
      
      
var test=true;
var result="";
var result1="";
var result2="";
      
            if(syear>eyear)
   {
    test=false;
    result="Dont select From date greater than  To date !"

   }

   else if(syear == eyear) 

  {
     
    if(smonth>emonth)
      
       {
          test=false;
          result="Dont select From date greater than  To date !"

       }
    
    else if(smonth == emonth)
         {

            if(sdate > edate)
            { 
              test=false;
              result="Dont select From date greater than  To date !";

            }
            

         }

         else
          {
            

          }



  }

else
 
	{
            

	}




  if(syear>y)
   {

       
                test=false;
                result1=result1 +"Dont select From date as   future date !";


   }

  
   
   
    else if(y == syear) 

  {
     
    if(smonth>m)
      
       {
                  test=false;
                result1=result1 +"Dont select From date as   future date !";
       }
    
  
    
    
    if(m == smonth)
         {

            if( sdate>d)
            { 
               test=false;
                result1=result1 +"Dont select From date as   future date !";

            }
            

         }

         else
          {
            
              
          }



  }

else
 
	{
              

	}





     
     if(eyear>y)
   {

                test=false;
                result2=result2 +"Dont select To date as   future date !";

   }

  
   
   
    else if(y == eyear) 

  {
     
    if(emonth>m)
      
       {
                test=false;
                result2=result2 +"Dont select To date as   future date !";

       }
    
  
    
    
    if(m == emonth)
         {

            if( edate>d)
            { 
                test=false;
                result2=result2 +"Dont select To date as   future date !";


            }
            

         }

         else
          {
            
             
          }



  }

else
 
	{
              

	}
	
	 if(result!= "" && result1!= "" )
	 {
	    result="";
	 }
	
	
	   if(test==false)
	   {
	      alert(result+"\n"+result1+"\n"+result2);
	      document.getElementById('fade').style.display='none'
	      return false;
	   
	   }
	   
	   
      if(test==true)
	   {
	   document.getElementById('fade').style.display='block'
       return true;
	   }       
	   
	 return true;
	}
	
