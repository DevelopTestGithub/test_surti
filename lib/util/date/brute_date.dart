//Brute force change dates to spanish
class BruteDate {
  
  static String monthToMes(String month)
  {
    switch(month)
    {
      case "January":
        return "Enero";  
      case "Febuary":
        return "Febrero";  
      case "March":
        return "Marzo";  
      case "April":
        return "Abril";  
      case "May":
        return "Mayo";  
      case "June":
        return "Junio";  
      case "July":
        return "Julio";   
      case "August":
        return "Agosto";   
      case "September":
        return "Septiembre";   
      case "October":
        return "Octubre";   
      case "November":
        return "Noviembre";  
      default:
        return "Diciembre";
    }
  }
}
