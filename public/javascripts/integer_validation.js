//To validate numericality of a text field


function check_float(d)
{
 var num=document.getElementById(d).value;
 var sText=new String(num);
 var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char; 

 
   for (var i = 0; i < sText.length && IsNumber == true; i++) 
      { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) 
         {
          IsNumber = false;
          document.getElementById(d).value="";
         
         }
      }
 
 
 
}




function check_numeric(d)
{
 var num=document.getElementById(d).value;
 var sText=new String(num);
 var ValidChars = "0123456789";
   var IsNumber=true;
   var Char; 

 
   for (var i = 0; i < sText.length && IsNumber == true; i++) 
      { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) 
         {
          IsNumber = false;
          document.getElementById(d).value="";
         
         }
      }
 
 
 
}