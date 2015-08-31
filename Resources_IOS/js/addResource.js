//var getResource;
//var clearAll

var onLoad = function (){
    
    var res = new Resource("","");
    ko.applyBindings(res);
    
    getResource = function(){
        
        return ko.toJSON(res)
    }
    clearAll = function() {
        res.title("")
        res.link("")
    }
}

