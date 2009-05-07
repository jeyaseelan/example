
      //****Copywrite CoastWorx http://www.coastworx.com Version 1.1******
      //****Please make a donation if you wish to remove this notice!******
      var myRow=1;
      var myCol=1;
      var speed=100; //timeout speed
      var myTable;
      var noRows;
      var myCells,ID;
      
    
      
    function setUp(){
    	if(!myTable){myTable=document.getElementById("t1");}
     	myCells = myTable.rows[0].cells.length;
    	noRows=myTable.rows.length;
    
    	for( var x = 0; x < myTable.rows[0].cells.length; x++ ) {
    		colWdth=myTable.rows[0].cells[x].offsetWidth;
    		myTable.rows[0].cells[x].setAttribute("width",colWdth-4);
    
    	} 
    }
    
    
    function right(up){
    	if(up){window.clearTimeout(ID);return;}
    	if(!myTable){setUp();}
    
    	if(myCol<(myCells)){
    		for( var x = 0; x < noRows; x++ ) {
    			myTable.rows[x].cells[myCol].style.display="";
    		}
    		if(myCol >1){myCol--;}
    
    		ID = window.setTimeout('right()',speed);
    	}
    }
      
    function left(up){
       if(up){window.clearTimeout(ID);return;}
    	if(!myTable){setUp();}
    
    	if(myCol<(myCells-12)){
    		for( var x = 0; x < noRows; x++ ) {
    			myTable.rows[x].cells[myCol].style.display="none";
    		}
    		myCol++
    		ID = window.setTimeout('left()',speed);
    		
    	}
    }
      
    function down1(up){
    	if(up){window.clearTimeout(ID);return;}
    	if(!myTable){setUp();}
    
    	if(myRow<(noRows-8)){
    			myTable.rows[myRow].style.display="none";
    			myRow++	;
    		
    			ID = window.setTimeout('down1()',speed);
    	}	
    }
     
    function upp(up){
    	if(up){window.clearTimeout(ID);return;}
    	if(!myTable){ setUp();}
    
    	if(myRow<=noRows){
    		myTable.rows[myRow].style.display="";
    		if(myRow >1){myRow--;}
    		ID = window.setTimeout('upp()',speed);
    	}	
    }
    
   