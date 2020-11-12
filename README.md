Structure:

  Api:
  
    - apiConection document have the conection with the api ApiSpreadSheets.
    
    - The first function is Future<List<dynamic>> loadCsvData(), there you can take the data of your excel and return it to the calendarList document.
    
    - The second function Future<http.Response> createCsv(List list), is to give the list of data that you get it ealier and send it with the changes.
  
  Model:
  
     - contenedor document is for create a container object from each cell of the api data list
     
     - doubleRow document is for create a object of a index of a doubleRow
     
  
  Widget:
  
     -calendarList document is the main document, there you get the list of the api and put it as containers in a gridview.
     
     -First i call to the api to get the data of the excel and then i create a list of contenedor object with the data that i get earlier.
     
     -Then i create containers for each object contenedor that i have and i put it inside a gridview.
     
     -In each container i can click it to change the data of it, when i click on it appears another page with textfields and color to change the data.
     
  
  Page:
  
     -modal document is the second page that i have to change the data of the containers.
     
     -There are 3 textfields , one colorpicker and one dropdownbutton to put how many hours it takes.
     
     -There is one raisebutton to finish the changes and that calls to the function in apiConection that change the data of the list and write it in the api.
     
    
Application:

DayMode:
     
<img src="/lib/images/CalendarDay.png" width="200" height="400"/>


<img src="/lib/images/ModalDay.png" width="200" height="400"/>

        
DarkMode:


<img src="/lib/images/CalendarDark.png" width="200" height="400"/>


<img src="/lib/images/ModalDark.png" width="200" height="400"/>
    
