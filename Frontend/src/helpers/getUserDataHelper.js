import config from "../config.json";

export const GetUserData = () => {
    var userData = false
    if (localStorage.getItem("token") != null){
        var request = new XMLHttpRequest();
        const url = config.BASE_URL_API + config.TOKEN.GET_DATA + "?token="+localStorage.getItem("token")        
        request.open('GET', url, false);  // `false` makes the request synchronous
        request.setRequestHeader("Access-Control-Allow-Origin", "origin-list")
        request.setRequestHeader("Token", localStorage.getItem("token"))         
        request.send(null)
        
        if (request.status === 200){
            return JSON.parse(request.responseText)          
        }
    }    
    return userData
}